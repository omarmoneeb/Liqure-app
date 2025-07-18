import 'package:flutter/foundation.dart';
import '../network/pocketbase_client.dart';

/// Comprehensive error handler for authentication operations
class AuthErrorHandler {
  /// Convert various auth errors to user-friendly messages
  static String getErrorMessage(dynamic error) {
    if (error is PocketBaseConnectionException) {
      return 'Cannot connect to server. Please check your internet connection or try demo mode.';
    }
    
    if (error is PocketBaseAuthException) {
      return _handlePocketBaseAuthError(error.message);
    }
    
    // Handle generic exceptions
    final errorString = error.toString();
    
    // Connection related errors
    if (errorString.contains('Connection refused') || 
        errorString.contains('Connection failed') ||
        errorString.contains('Connection timed out')) {
      return 'Connection failed. Please check your internet connection or try demo mode.';
    }
    
    // Network related errors
    if (errorString.contains('Network unreachable') ||
        errorString.contains('No address associated with hostname') ||
        errorString.contains('Failed host lookup')) {
      return 'Network error. Please check your internet connection.';
    }
    
    // Authentication specific errors
    if (errorString.contains('Invalid credentials') ||
        errorString.contains('Authentication failed') ||
        errorString.contains('Invalid login credentials')) {
      return 'Invalid email or password. Please check your credentials.';
    }
    
    if (errorString.contains('User not found') ||
        errorString.contains('Record not found')) {
      return 'No account found with this email address.';
    }
    
    if (errorString.contains('Email already exists') ||
        errorString.contains('User already exists')) {
      return 'An account with this email address already exists.';
    }
    
    // Password related errors
    if (errorString.contains('Password too short') ||
        errorString.contains('Password must be at least')) {
      return 'Password must be at least 8 characters long.';
    }
    
    if (errorString.contains('Password confirmation') ||
        errorString.contains('Passwords do not match')) {
      return 'Password confirmation does not match.';
    }
    
    // Email validation errors
    if (errorString.contains('Invalid email format') ||
        errorString.contains('Invalid email')) {
      return 'Please enter a valid email address.';
    }
    
    // Server errors
    if (errorString.contains('Internal server error') ||
        errorString.contains('Server error')) {
      return 'Server error. Please try again later.';
    }
    
    if (errorString.contains('Service unavailable') ||
        errorString.contains('Server unavailable')) {
      return 'Service temporarily unavailable. Please try again later.';
    }
    
    // Rate limiting
    if (errorString.contains('Too many requests') ||
        errorString.contains('Rate limit exceeded')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    
    // Generic fallback
    if (kDebugMode) {
      debugPrint('🔍 AuthErrorHandler: Unhandled error: $errorString');
    }
    
    return 'An error occurred. Please try again or use demo mode.';
  }
  
  /// Handle PocketBase specific authentication errors
  static String _handlePocketBaseAuthError(String errorMessage) {
    // Extract meaningful error from PocketBase response
    final lowerError = errorMessage.toLowerCase();
    
    if (lowerError.contains('failed to authenticate')) {
      return 'Invalid email or password. Please check your credentials.';
    }
    
    if (lowerError.contains('email validation')) {
      return 'Please enter a valid email address.';
    }
    
    if (lowerError.contains('password validation')) {
      return 'Password must be at least 8 characters long.';
    }
    
    if (lowerError.contains('username validation')) {
      return 'Username must be at least 3 characters long.';
    }
    
    if (lowerError.contains('record not found')) {
      return 'No account found with this email address.';
    }
    
    if (lowerError.contains('record already exists')) {
      return 'An account with this email address already exists.';
    }
    
    // Return original message if no specific handler found
    return errorMessage;
  }
  
  /// Check if error indicates a connection issue
  static bool isConnectionError(dynamic error) {
    if (error is PocketBaseConnectionException) {
      return true;
    }
    
    final errorString = error.toString().toLowerCase();
    
    return errorString.contains('connection refused') ||
           errorString.contains('connection failed') ||
           errorString.contains('connection timed out') ||
           errorString.contains('network unreachable') ||
           errorString.contains('no address associated') ||
           errorString.contains('failed host lookup') ||
           errorString.contains('server unavailable') ||
           errorString.contains('service unavailable');
  }
  
  /// Check if error indicates an authentication issue
  static bool isAuthError(dynamic error) {
    if (error is PocketBaseAuthException) {
      return true;
    }
    
    final errorString = error.toString().toLowerCase();
    
    return errorString.contains('invalid credentials') ||
           errorString.contains('authentication failed') ||
           errorString.contains('invalid login credentials') ||
           errorString.contains('failed to authenticate') ||
           errorString.contains('user not found') ||
           errorString.contains('record not found');
  }
  
  /// Check if error indicates a validation issue
  static bool isValidationError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    return errorString.contains('validation') ||
           errorString.contains('invalid email') ||
           errorString.contains('password too short') ||
           errorString.contains('password must be') ||
           errorString.contains('passwords do not match') ||
           errorString.contains('username must be');
  }
  
  /// Get appropriate action suggestions based on error type
  static List<String> getActionSuggestions(dynamic error) {
    if (isConnectionError(error)) {
      return [
        'Check your internet connection',
        'Try again in a few moments',
        'Use demo mode to explore the app',
        'Connect to a different network',
      ];
    }
    
    if (isAuthError(error)) {
      return [
        'Double-check your email and password',
        'Try forgot password if you have an account',
        'Create a new account if you don\'t have one',
        'Contact support if the problem persists',
      ];
    }
    
    if (isValidationError(error)) {
      return [
        'Check the format of your input',
        'Ensure password meets requirements',
        'Verify email address is correct',
        'Try a different username if taken',
      ];
    }
    
    return [
      'Try again in a few moments',
      'Restart the app if the issue persists',
      'Contact support if needed',
    ];
  }
}