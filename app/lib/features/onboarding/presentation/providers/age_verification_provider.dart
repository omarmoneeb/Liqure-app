import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing age verification state
class AgeVerificationNotifier extends StateNotifier<bool> {
  AgeVerificationNotifier() : super(false) {
    _loadAgeVerificationStatus();
  }

  static const String _ageVerifiedKey = 'age_verified';

  /// Load age verification status from SharedPreferences
  Future<void> _loadAgeVerificationStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isVerified = prefs.getBool(_ageVerifiedKey) ?? false;
      print('📱 Age Verification: Loaded status - $isVerified');
      state = isVerified;
    } catch (e) {
      print('❌ Age Verification: Error loading status - $e');
      state = false;
    }
  }

  /// Set age verification status and persist to SharedPreferences
  Future<void> setAgeVerified(bool isVerified) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_ageVerifiedKey, isVerified);
      print('📱 Age Verification: Set status to $isVerified');
      state = isVerified;
    } catch (e) {
      print('❌ Age Verification: Error saving status - $e');
      throw Exception('Failed to save age verification status');
    }
  }

  /// Clear age verification (for testing or reset purposes)
  Future<void> clearAgeVerification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_ageVerifiedKey);
      print('📱 Age Verification: Cleared verification status');
      state = false;
    } catch (e) {
      print('❌ Age Verification: Error clearing status - $e');
      throw Exception('Failed to clear age verification status');
    }
  }

  /// Check if user needs to verify age (convenience method)
  bool get needsVerification => !state;
}

/// Provider instance for age verification
final ageVerificationProvider = StateNotifierProvider<AgeVerificationNotifier, bool>((ref) {
  return AgeVerificationNotifier();
});

/// Provider for checking if age verification is complete
final isAgeVerifiedProvider = Provider<bool>((ref) {
  return ref.watch(ageVerificationProvider);
});

/// Provider for getting the age verification notifier
final ageVerificationNotifierProvider = Provider<AgeVerificationNotifier>((ref) {
  return ref.read(ageVerificationProvider.notifier);
});