import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/scan_result.dart';
import '../../../tasting/presentation/providers/tasting_providers.dart';

/// Provider for managing scan state and results
class ScannerNotifier extends StateNotifier<List<ScanResult>> {
  ScannerNotifier(this._ref) : super([]);

  final Ref _ref;

  /// Process a new scan result
  Future<void> processScanResult(ScanResult scanResult) async {
    print('🔍 Scanner: Processing scan result - ${scanResult.barcode}');

    try {
      // Search for drinks with this barcode
      final drinksRepository = _ref.read(drinksRepositoryProvider);
      final drink = await drinksRepository.getDrinkByBarcode(scanResult.barcode);

      // Update scan result with search results
      final updatedResult = scanResult.copyWith(
        found: drink != null,
        drinkId: drink?.id,
        drinkName: drink?.name,
      );

      // Add to scan history
      state = [updatedResult, ...state];
      
      print('🔍 Scanner: Scan processed - found: ${drink != null}, drink: ${drink?.name}');
    } catch (e) {
      print('❌ Scanner: Error processing scan result - $e');
      
      // Add failed scan to history
      final failedResult = scanResult.copyWith(found: false);
      state = [failedResult, ...state];
    }
  }

  /// Clear scan history
  void clearHistory() {
    state = [];
    print('🔍 Scanner: Scan history cleared');
  }

  /// Get recent scans
  List<ScanResult> getRecentScans({int limit = 10}) {
    return state.take(limit).toList();
  }

  /// Get successful scans only
  List<ScanResult> getSuccessfulScans() {
    return state.where((scan) => scan.found == true).toList();
  }
}

/// Provider instance for scanner state
final scannerProvider = StateNotifierProvider<ScannerNotifier, List<ScanResult>>((ref) {
  return ScannerNotifier(ref);
});

/// Provider for recent scan results
final recentScansProvider = Provider<List<ScanResult>>((ref) {
  final scans = ref.watch(scannerProvider);
  return scans.take(10).toList();
});

/// Provider for successful scans only
final successfulScansProvider = Provider<List<ScanResult>>((ref) {
  final scans = ref.watch(scannerProvider);
  return scans.where((scan) => scan.found == true).toList();
});