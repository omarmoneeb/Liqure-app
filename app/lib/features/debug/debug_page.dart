import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/seed_runner.dart';
import '../../core/database/seed_data.dart';
import '../../core/network/pocketbase_client.dart';
import '../onboarding/presentation/providers/age_verification_provider.dart';

class DebugPage extends ConsumerStatefulWidget {
  const DebugPage({super.key});

  @override
  ConsumerState<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends ConsumerState<DebugPage> {
  bool _isLoading = false;
  String _statusMessage = '';
  int _currentDrinksCount = 0;

  @override
  void initState() {
    super.initState();
    _checkDrinksCount();
  }

  Future<void> _checkDrinksCount() async {
    try {
      final seedData = SeedData(ref.read(pocketBaseClientProvider));
      final count = await seedData.getDrinksCount();
      setState(() {
        _currentDrinksCount = count;
        _statusMessage = 'Database has $_currentDrinksCount drinks';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error checking drinks count: $e';
      });
    }
  }

  Future<void> _seedDatabase() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Seeding database...';
    });

    try {
      final seedRunner = ref.read(seedRunnerProvider);
      await seedRunner.runSeeding();
      await _checkDrinksCount();
      setState(() {
        _statusMessage = 'Database seeded successfully! Now has $_currentDrinksCount drinks.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error seeding database: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearDatabase() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing database...';
    });

    try {
      final seedRunner = ref.read(seedRunnerProvider);
      await seedRunner.clearDatabase();
      await _checkDrinksCount();
      setState(() {
        _statusMessage = 'Database cleared successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error clearing database: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAgeVerified = ref.watch(ageVerificationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Tools'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Age Verification Debug Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Age Verification Debug',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current Status: ${isAgeVerified ? "✅ Verified" : "❌ Not Verified"}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isAgeVerified ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await ref.read(ageVerificationProvider.notifier).clearAgeVerification();
                              if (context.mounted) {
                                context.go('/age-gate');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Reset Age Gate'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await ref.read(ageVerificationProvider.notifier).setAgeVerified(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Force Verify'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Database Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _statusMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _checkDrinksCount,
                      child: const Text('Refresh Status'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Database Actions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _seedDatabase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Seed Database'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _clearDatabase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Clear Database'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seed Data Info',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The seed data contains ${SeedData.popularSpirits.length} popular spirits including:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('• Whiskey (Jameson, Jack Daniel\'s, Macallan, etc.)'),
                    const Text('• Vodka (Grey Goose, Absolut, Belvedere, etc.)'),
                    const Text('• Gin (Tanqueray, Hendrick\'s, Bombay Sapphire)'),
                    const Text('• Rum (Bacardi, Captain Morgan, Mount Gay)'),
                    const Text('• Tequila (Patrón, Don Julio, Herradura)'),
                    const Text('• Mezcal (Del Maguey, Montelobos)'),
                    const Text('• Liqueurs (Grand Marnier, Kahlúa, Baileys)'),
                    const Text('• Wine & Beer examples'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}