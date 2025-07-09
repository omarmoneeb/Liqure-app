import '../entities/user.dart';

abstract class AuthRepository {
  /// Get current authenticated user
  Future<User?> getCurrentUser();
  
  /// Sign in with email and password
  Future<User> signInWithEmail(String email, String password);
  
  /// Sign up with email and password
  Future<User> signUpWithEmail(String email, String password, {String? username});
  
  /// Sign out current user
  Future<void> signOut();
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
  
  /// Refresh authentication token
  Future<void> refreshToken();
  
  /// Send password reset email
  Future<void> sendPasswordReset(String email);
  
  /// Update user profile
  Future<User> updateProfile({
    String? username,
    String? avatar,
  });
  
  /// Delete user account
  Future<void> deleteAccount();
}