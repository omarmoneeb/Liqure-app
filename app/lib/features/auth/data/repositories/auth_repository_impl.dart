import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../../../../core/network/pocketbase_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final PocketBaseClient _pocketBaseClient;
  final SharedPreferences _prefs;
  
  AuthRepositoryImpl(this._pocketBaseClient, this._prefs);
  
  @override
  Future<User?> getCurrentUser() async {
    try {
      final currentUser = _pocketBaseClient.getCurrentUser();
      if (currentUser != null) {
        final userModel = UserModel.fromPocketBase(currentUser.toJson());
        return userModel.toEntity();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final authResult = await _pocketBaseClient.signInWithEmail(email, password);
      final userModel = UserModel.fromPocketBase(authResult.record!.toJson());
      
      // Store user data locally
      await _storeUserLocally(userModel);
      
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }
  
  @override
  Future<User> signUpWithEmail(String email, String password, {String? username}) async {
    try {
      await _pocketBaseClient.signUpWithEmail(email, password, username: username);
      
      // After creating account, sign in to get auth token
      final authResult = await _pocketBaseClient.signInWithEmail(email, password);
      final userModel = UserModel.fromPocketBase(authResult.record!.toJson());
      
      // Store user data locally
      await _storeUserLocally(userModel);
      
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      _pocketBaseClient.signOut();
      await _clearUserLocally();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    return _pocketBaseClient.isAuthenticated();
  }
  
  @override
  Future<void> refreshToken() async {
    try {
      await _pocketBaseClient.refreshToken();
    } catch (e) {
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }
  
  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _pocketBaseClient.sendPasswordReset(email);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }
  
  @override
  Future<User> updateProfile({String? username, String? avatar}) async {
    try {
      final currentUser = _pocketBaseClient.getCurrentUser();
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }
      
      final updateData = <String, dynamic>{};
      if (username != null) updateData['username'] = username;
      if (avatar != null) updateData['avatar'] = avatar;
      
      final updatedRecord = await _pocketBaseClient.updateProfile(currentUser.id, updateData);
      final userModel = UserModel.fromPocketBase(updatedRecord.toJson());
      
      // Update local storage
      await _storeUserLocally(userModel);
      
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteAccount() async {
    try {
      final currentUser = _pocketBaseClient.getCurrentUser();
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }
      
      await _pocketBaseClient.deleteUser(currentUser.id);
      await _clearUserLocally();
    } catch (e) {
      throw Exception('Account deletion failed: ${e.toString()}');
    }
  }
  
  // Helper methods for local storage
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