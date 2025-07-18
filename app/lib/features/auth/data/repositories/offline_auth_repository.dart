import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../../../../core/network/pocketbase_client.dart';

/// Offline-first authentication repository that can work without PocketBase
class OfflineAuthRepository implements AuthRepository {
  final PocketBaseClient _pocketBaseClient;
  final SharedPreferences _prefs;
  final _uuid = const Uuid();
  
  // Local storage keys
  static const String _usersKey = 'offline_users';
  static const String _currentUserKey = 'current_offline_user';
  static const String _demoModeKey = 'demo_mode_enabled';
  
  OfflineAuthRepository(this._pocketBaseClient, this._prefs);
  
  @override
  Future<User?> getCurrentUser() async {
    try {
      // First try to get current user from PocketBase if available
      if (await _pocketBaseClient.isServerReachable()) {
        final currentUser = _pocketBaseClient.getCurrentUser();
        if (currentUser != null) {
          final userModel = UserModel.fromPocketBase(currentUser.toJson());
          return userModel.toEntity();
        }
      }
      
      // Fall back to offline user
      final offlineUser = await _getOfflineCurrentUser();
      if (offlineUser != null) {
        return offlineUser;
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ OfflineAuthRepository: Error getting current user: $e');
      }
      return await _getOfflineCurrentUser();
    }
  }
  
  @override
  Future<User> signInWithEmail(String email, String password) async {
    try {
      // Try online authentication first
      if (await _pocketBaseClient.isServerReachable()) {
        final authResult = await _pocketBaseClient.signInWithEmail(email, password);
        final userModel = UserModel.fromPocketBase(authResult.record!.toJson());
        
        // Store user data locally for offline access
        await _storeUserLocally(userModel);
        await _setCurrentOfflineUser(userModel.toEntity());
        
        return userModel.toEntity();
      }
      
      // Fall back to offline authentication
      final offlineUser = await _authenticateOffline(email, password);
      if (offlineUser != null) {
        await _setCurrentOfflineUser(offlineUser);
        return offlineUser;
      }
      
      throw Exception('Authentication failed: Invalid credentials or server unavailable');
    } catch (e) {
      if (e is PocketBaseConnectionException) {
        // Try offline authentication
        final offlineUser = await _authenticateOffline(email, password);
        if (offlineUser != null) {
          await _setCurrentOfflineUser(offlineUser);
          return offlineUser;
        }
      }
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }
  
  @override
  Future<User> signUpWithEmail(String email, String password, {String? username}) async {
    try {
      // Try online registration first
      if (await _pocketBaseClient.isServerReachable()) {
        await _pocketBaseClient.signUpWithEmail(email, password, username: username);
        
        // After creating account, sign in to get auth token
        final authResult = await _pocketBaseClient.signInWithEmail(email, password);
        final userModel = UserModel.fromPocketBase(authResult.record!.toJson());
        
        // Store user data locally
        await _storeUserLocally(userModel);
        await _setCurrentOfflineUser(userModel.toEntity());
        
        return userModel.toEntity();
      }
      
      // Fall back to offline registration
      final offlineUser = await _registerOffline(email, password, username);
      await _setCurrentOfflineUser(offlineUser);
      
      return offlineUser;
    } catch (e) {
      if (e is PocketBaseConnectionException) {
        // Try offline registration
        final offlineUser = await _registerOffline(email, password, username);
        await _setCurrentOfflineUser(offlineUser);
        return offlineUser;
      }
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      // Clear PocketBase auth if available
      if (await _pocketBaseClient.isServerReachable()) {
        _pocketBaseClient.signOut();
      }
      
      // Clear offline auth
      await _clearOfflineAuth();
    } catch (e) {
      // Always clear offline auth even if PocketBase fails
      await _clearOfflineAuth();
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    try {
      // Check PocketBase auth first
      if (await _pocketBaseClient.isServerReachable()) {
        if (_pocketBaseClient.isAuthenticated()) {
          return true;
        }
      }
      
      // Check offline auth
      final offlineUser = await _getOfflineCurrentUser();
      return offlineUser != null;
    } catch (e) {
      // Fall back to offline auth check
      final offlineUser = await _getOfflineCurrentUser();
      return offlineUser != null;
    }
  }
  
  @override
  Future<void> refreshToken() async {
    try {
      if (await _pocketBaseClient.isServerReachable()) {
        await _pocketBaseClient.refreshToken();
      }
      // Offline tokens don't need refreshing
    } catch (e) {
      // Ignore token refresh errors in offline mode
      if (kDebugMode) {
        debugPrint('⚠️ OfflineAuthRepository: Token refresh failed (offline mode): $e');
      }
    }
  }
  
  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      if (await _pocketBaseClient.isServerReachable()) {
        await _pocketBaseClient.sendPasswordReset(email);
      } else {
        throw Exception('Password reset requires internet connection');
      }
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }
  
  @override
  Future<User> updateProfile({String? username, String? avatar}) async {
    try {
      // Try online update first
      if (await _pocketBaseClient.isServerReachable()) {
        final currentUser = _pocketBaseClient.getCurrentUser();
        if (currentUser != null) {
          final updateData = <String, dynamic>{};
          if (username != null) updateData['username'] = username;
          if (avatar != null) updateData['avatar'] = avatar;
          
          final updatedRecord = await _pocketBaseClient.updateProfile(currentUser.id, updateData);
          final userModel = UserModel.fromPocketBase(updatedRecord.toJson());
          
          // Update local storage
          await _storeUserLocally(userModel);
          await _setCurrentOfflineUser(userModel.toEntity());
          
          return userModel.toEntity();
        }
      }
      
      // Fall back to offline update
      final offlineUser = await _updateOfflineProfile(username: username, avatar: avatar);
      if (offlineUser != null) {
        await _setCurrentOfflineUser(offlineUser);
        return offlineUser;
      }
      
      throw Exception('No authenticated user');
    } catch (e) {
      if (e is PocketBaseConnectionException) {
        final offlineUser = await _updateOfflineProfile(username: username, avatar: avatar);
        if (offlineUser != null) {
          await _setCurrentOfflineUser(offlineUser);
          return offlineUser;
        }
      }
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteAccount() async {
    try {
      // Try online deletion first
      if (await _pocketBaseClient.isServerReachable()) {
        final currentUser = _pocketBaseClient.getCurrentUser();
        if (currentUser != null) {
          await _pocketBaseClient.deleteUser(currentUser.id);
        }
      }
      
      // Always clear offline data
      await _clearOfflineAuth();
      await _clearUserLocally();
    } catch (e) {
      // Always clear offline data even if online deletion fails
      await _clearOfflineAuth();
      await _clearUserLocally();
    }
  }
  
  /// Enable demo mode for testing without authentication
  Future<void> enableDemoMode() async {
    if (kDebugMode) {
      debugPrint('🎭 OfflineAuthRepository: Enabling demo mode');
    }
    
    await _prefs.setBool(_demoModeKey, true);
    
    // Create a demo user
    final demoUser = User(
      id: 'demo_user_123',
      email: 'demo@example.com',
      username: 'Demo User',
      created: DateTime.now(),
      updated: DateTime.now(),
    );
    
    await _setCurrentOfflineUser(demoUser);
  }
  
  /// Check if demo mode is enabled
  Future<bool> isDemoModeEnabled() async {
    return _prefs.getBool(_demoModeKey) ?? false;
  }
  
  /// Disable demo mode
  Future<void> disableDemoMode() async {
    if (kDebugMode) {
      debugPrint('🎭 OfflineAuthRepository: Disabling demo mode');
    }
    
    await _prefs.setBool(_demoModeKey, false);
    await _clearOfflineAuth();
  }
  
  // Private methods for offline authentication
  
  Future<User?> _authenticateOffline(String email, String password) async {
    final users = await _getOfflineUsers();
    final hashedPassword = _hashPassword(password);
    
    for (final userData in users) {
      if (userData['email'] == email && userData['password'] == hashedPassword) {
        return User(
          id: userData['id'],
          email: userData['email'],
          username: userData['username'],
          created: DateTime.parse(userData['created']),
          updated: DateTime.parse(userData['updated']),
        );
      }
    }
    
    return null;
  }
  
  Future<User> _registerOffline(String email, String password, String? username) async {
    final users = await _getOfflineUsers();
    
    // Check if user already exists
    for (final userData in users) {
      if (userData['email'] == email) {
        throw Exception('User with this email already exists');
      }
    }
    
    final userId = _uuid.v4();
    final hashedPassword = _hashPassword(password);
    final now = DateTime.now();
    
    final newUser = {
      'id': userId,
      'email': email,
      'username': username ?? email.split('@')[0],
      'password': hashedPassword,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };
    
    users.add(newUser);
    await _saveOfflineUsers(users);
    
    return User(
      id: userId,
      email: email,
      username: username ?? email.split('@')[0],
      created: now,
      updated: now,
    );
  }
  
  Future<User?> _updateOfflineProfile({String? username, String? avatar}) async {
    final currentUser = await _getOfflineCurrentUser();
    if (currentUser == null) return null;
    
    final users = await _getOfflineUsers();
    
    for (int i = 0; i < users.length; i++) {
      if (users[i]['id'] == currentUser.id) {
        if (username != null) {
          users[i]['username'] = username;
        }
        if (avatar != null) {
          users[i]['avatar'] = avatar;
        }
        users[i]['updatedAt'] = DateTime.now().toIso8601String();
        break;
      }
    }
    
    await _saveOfflineUsers(users);
    
    return User(
      id: currentUser.id,
      email: currentUser.email,
      username: username ?? currentUser.username,
      created: currentUser.created,
      updated: DateTime.now(),
    );
  }
  
  Future<List<Map<String, dynamic>>> _getOfflineUsers() async {
    final usersJson = _prefs.getString(_usersKey) ?? '[]';
    final usersList = jsonDecode(usersJson) as List;
    return usersList.cast<Map<String, dynamic>>();
  }
  
  Future<void> _saveOfflineUsers(List<Map<String, dynamic>> users) async {
    await _prefs.setString(_usersKey, jsonEncode(users));
  }
  
  Future<User?> _getOfflineCurrentUser() async {
    final userJson = _prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    
    final userData = jsonDecode(userJson) as Map<String, dynamic>;
    return User(
      id: userData['id'],
      email: userData['email'],
      username: userData['username'],
      created: DateTime.parse(userData['created']),
      updated: DateTime.parse(userData['updated']),
    );
  }
  
  Future<void> _setCurrentOfflineUser(User user) async {
    final userData = {
      'id': user.id,
      'email': user.email,
      'username': user.username,
      'createdAt': user.created?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updatedAt': user.updated?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
    
    await _prefs.setString(_currentUserKey, jsonEncode(userData));
  }
  
  Future<void> _clearOfflineAuth() async {
    await _prefs.remove(_currentUserKey);
  }
  
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Helper methods for local storage (from original implementation)
  Future<void> _storeUserLocally(UserModel user) async {
    await _prefs.setString('user_id', user.id);
    await _prefs.setString('user_email', user.email);
    if (user.username != null) {
      await _prefs.setString('user_username', user.username!);
    }
  }
  
  Future<void> _clearUserLocally() async {
    await _prefs.remove('user_id');
    await _prefs.remove('user_email');
    await _prefs.remove('user_username');
  }
}