import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../config/app_config.dart';

class PocketBaseClient {
  late final String baseUrl;
  late final PocketBase _pb;
  final Connectivity _connectivity = Connectivity();
  
  PocketBaseClient() {
    // Use configuration from AppConfig with a safe fallback
    try {
      baseUrl = AppConfig.pocketbaseUrl;
    } catch (e) {
      // Fallback if AppConfig hasn't been initialized yet
      baseUrl = 'http://10.1.0.71:8090';
      if (kDebugMode) {
        debugPrint('⚠️ PocketBaseClient: AppConfig not initialized, using fallback URL: $baseUrl');
      }
    }
    if (kDebugMode) {
      debugPrint('🔧 PocketBaseClient: Initializing with baseUrl: $baseUrl');
      if (baseUrl.contains('localhost')) {
        debugPrint('⚠️ PocketBaseClient: Using localhost - this may not work on physical devices');
        debugPrint('💡 To fix: Set DEV_IP in .env file to your machine\'s IP address');
      }
    }
    _pb = PocketBase(baseUrl);
    if (kDebugMode) {
      debugPrint('🔧 PocketBaseClient: Initialized successfully');
    }
  }
  
  /// Check if device is connected to internet
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ PocketBaseClient: Error checking connectivity: $e');
      }
      return false;
    }
  }
  
  /// Check if PocketBase server is reachable
  Future<bool> isServerReachable() async {
    try {
      if (!await isConnected()) {
        if (kDebugMode) {
          debugPrint('⚠️ PocketBaseClient: No internet connection');
        }
        return false;
      }
      
      // Try to get health status with timeout
      await _pb.health.check().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Server health check timed out', const Duration(seconds: 5));
        },
      );
      
      if (kDebugMode) {
        debugPrint('✅ PocketBaseClient: Server is reachable');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ PocketBaseClient: Server not reachable: $e');
        if (baseUrl.contains('localhost')) {
          debugPrint('💡 If using a physical device, localhost won\'t work');
          debugPrint('💡 Set DEV_IP in .env file to your machine\'s IP address');
        }
      }
      return false;
    }
  }
  
  PocketBase get instance => _pb;
  
  // Auth methods
  Future<RecordAuth> signInWithEmail(String email, String password) async {
    if (!await isServerReachable()) {
      throw PocketBaseConnectionException('Cannot connect to authentication server. Please check your internet connection.');
    }
    
    try {
      return await _pb.collection('users').authWithPassword(email, password);
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('❌ PocketBaseClient: Sign in failed: $e');
      }
      throw PocketBaseAuthException('Authentication failed: ${e.toString()}');
    }
  }
  
  Future<RecordModel> signUpWithEmail(String email, String password, {String? username}) async {
    if (!await isServerReachable()) {
      throw PocketBaseConnectionException('Cannot connect to authentication server. Please check your internet connection.');
    }
    
    try {
      final data = {
        'email': email,
        'password': password,
        'passwordConfirm': password,
        if (username != null) 'username': username,
      };
      
      return await _pb.collection('users').create(body: data);
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('❌ PocketBaseClient: Sign up failed: $e');
      }
      throw PocketBaseAuthException('Account creation failed: ${e.toString()}');
    }
  }
  
  void signOut() {
    _pb.authStore.clear();
  }
  
  bool isAuthenticated() {
    return _pb.authStore.isValid;
  }
  
  RecordModel? getCurrentUser() {
    return _pb.authStore.model;
  }
  
  Future<void> refreshToken() async {
    if (!_pb.authStore.isValid) {
      return;
    }
    
    if (!await isServerReachable()) {
      throw PocketBaseConnectionException('Cannot connect to authentication server to refresh token.');
    }
    
    try {
      await _pb.collection('users').authRefresh();
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('❌ PocketBaseClient: Token refresh failed: $e');
      }
      throw PocketBaseAuthException('Token refresh failed: ${e.toString()}');
    }
  }
  
  Future<void> sendPasswordReset(String email) async {
    if (!await isServerReachable()) {
      throw PocketBaseConnectionException('Cannot connect to authentication server to send password reset.');
    }
    
    try {
      await _pb.collection('users').requestPasswordReset(email);
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('❌ PocketBaseClient: Password reset failed: $e');
      }
      throw PocketBaseAuthException('Password reset failed: ${e.toString()}');
    }
  }
  
  Future<RecordModel> updateProfile(String id, Map<String, dynamic> data) async {
    if (!await isServerReachable()) {
      throw PocketBaseConnectionException('Cannot connect to authentication server to update profile.');
    }
    
    try {
      return await _pb.collection('users').update(id, body: data);
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('❌ PocketBaseClient: Profile update failed: $e');
      }
      throw PocketBaseAuthException('Profile update failed: ${e.toString()}');
    }
  }
  
  Future<void> deleteUser(String id) async {
    if (!await isServerReachable()) {
      throw PocketBaseConnectionException('Cannot connect to authentication server to delete account.');
    }
    
    try {
      await _pb.collection('users').delete(id);
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('❌ PocketBaseClient: User deletion failed: $e');
      }
      throw PocketBaseAuthException('Account deletion failed: ${e.toString()}');
    }
  }
}

/// Exception thrown when PocketBase server is not reachable
class PocketBaseConnectionException implements Exception {
  final String message;
  
  PocketBaseConnectionException(this.message);
  
  @override
  String toString() => 'PocketBaseConnectionException: $message';
}

/// Exception thrown when authentication fails
class PocketBaseAuthException implements Exception {
  final String message;
  
  PocketBaseAuthException(this.message);
  
  @override
  String toString() => 'PocketBaseAuthException: $message';
}

// Riverpod provider
final pocketBaseClientProvider = Provider<PocketBaseClient>((ref) {
  return PocketBaseClient();
});