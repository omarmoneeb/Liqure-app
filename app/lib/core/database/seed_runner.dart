import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/pocketbase_client.dart';
import 'seed_data.dart';

class SeedRunner {
  final PocketBaseClient _pocketBaseClient;
  
  SeedRunner(this._pocketBaseClient);
  
  Future<void> runSeeding() async {
    final seedData = SeedData(_pocketBaseClient);
    
    // Check if database already has drinks
    final currentCount = await seedData.getDrinksCount();
    print('Current drinks count: $currentCount');
    
    if (currentCount > 0) {
      print('Database already has $currentCount drinks.');
      print('Would you like to clear and re-seed? (This will delete all existing drinks)');
      // For now, let's skip if data already exists
      return;
    }
    
    // Seed the database
    await seedData.seedDrinks();
    
    // Verify seeding
    final finalCount = await seedData.getDrinksCount();
    print('Final drinks count: $finalCount');
  }
  
  Future<void> clearDatabase() async {
    final seedData = SeedData(_pocketBaseClient);
    await seedData.clearDrinks();
  }
}

// Provider for the seed runner
final seedRunnerProvider = Provider<SeedRunner>((ref) {
  final pocketBaseClient = ref.watch(pocketBaseClientProvider);
  return SeedRunner(pocketBaseClient);
});