import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/drink.dart';
import '../../domain/entities/rating.dart';
import '../providers/tasting_providers.dart';
import '../widgets/rating_widget.dart';
import '../widgets/rating_submission_dialog.dart';

class DrinkDetailPage extends ConsumerStatefulWidget {
  final String drinkId;

  const DrinkDetailPage({super.key, required this.drinkId});

  @override
  ConsumerState<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends ConsumerState<DrinkDetailPage> {
  @override
  Widget build(BuildContext context) {
    print('🔍 DrinkDetailPage: Building with drinkId="${widget.drinkId}"');
    
    final drinkAsync = ref.watch(drinkByIdProvider(widget.drinkId));
    final userRatingAsync = ref.watch(userDrinkRatingProvider(widget.drinkId));
    final averageRatingAsync = ref.watch(drinkAverageRatingProvider(widget.drinkId));
    
    drinkAsync.when(
      data: (drink) => print('🔍 DrinkDetailPage: Got drink data: ${drink?.id} - ${drink?.name}'),
      loading: () => print('🔍 DrinkDetailPage: Loading drink...'),
      error: (error, stack) => print('🔍 DrinkDetailPage: Error loading drink: $error'),
    );

    return Scaffold(
      body: drinkAsync.when(
        data: (drink) {
          if (drink == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Drink not found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/drinks'),
                    child: const Text('Back to Drinks'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar with image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: _getTypeColor(drink.type),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/drinks'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    drink.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _getTypeColor(drink.type),
                          _getTypeColor(drink.type).withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getTypeIcon(drink.type),
                        size: 120,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type and ABV badges
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: Icons.local_bar,
                            label: _getTypeDisplayName(drink.type),
                            color: _getTypeColor(drink.type),
                          ),
                          const SizedBox(width: 8),
                          if (drink.abv != null)
                            _buildInfoChip(
                              icon: Icons.percent,
                              label: '${drink.abv}% ABV',
                              color: Colors.orange,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Country info
                      if (drink.country != null) ...[
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 20, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Text(
                              drink.country!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Rating section
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Rating',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  averageRatingAsync.when(
                                    data: (avgRating) {
                                      if (avgRating == null) {
                                        return const Text(
                                          'No ratings yet',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        );
                                      }
                                      return Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 20),
                                          const SizedBox(width: 4),
                                          Text(
                                            avgRating.toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    loading: () => const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    error: (_, __) => const Text('Error'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // User rating
                              userRatingAsync.when(
                                data: (userRating) {
                                  if (userRating != null) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Your Rating',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        RatingWidget(
                                          rating: userRating.rating,
                                          size: 32,
                                          onRatingChanged: null, // Display only
                                        ),
                                        if (userRating.notes != null && userRating.notes!.isNotEmpty) ...[
                                          const SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              userRating.notes!,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            TextButton.icon(
                                              onPressed: () => _showRatingDialog(context, existingRating: userRating),
                                              icon: const Icon(Icons.edit, size: 18),
                                              label: const Text('Edit'),
                                            ),
                                            TextButton.icon(
                                              onPressed: () => _deleteRating(context, userRating.id),
                                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                              label: const Text('Delete', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                  
                                  return Column(
                                    children: [
                                      const Text(
                                        'Rate this drink',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton.icon(
                                        onPressed: () => _showRatingDialog(context),
                                        icon: const Icon(Icons.star_outline),
                                        label: const Text('Add Rating'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                error: (error, _) => Text('Error: $error'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      if (drink.description != null && drink.description!.isNotEmpty) ...[
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          drink.description!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(drinkByIdProvider(widget.drinkId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, {Rating? existingRating}) {
    showDialog(
      context: context,
      builder: (context) => RatingSubmissionDialog(
        drinkId: widget.drinkId,
        existingRating: existingRating,
      ),
    );
  }

  void _deleteRating(BuildContext context, String ratingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Rating'),
        content: const Text('Are you sure you want to delete your rating?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(ratingNotifierProvider.notifier).deleteRating(ratingId);
                
                // Refresh the rating data
                ref.refresh(userDrinkRatingProvider(widget.drinkId));
                ref.refresh(drinkAverageRatingProvider(widget.drinkId));
                ref.refresh(drinkRatingsProvider(widget.drinkId));
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rating deleted!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting rating: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(DrinkType type) {
    switch (type) {
      case DrinkType.whiskey:
      case DrinkType.bourbon:
      case DrinkType.scotch:
        return Colors.amber.shade700;
      case DrinkType.vodka:
        return Colors.blue.shade400;
      case DrinkType.gin:
        return Colors.green.shade600;
      case DrinkType.rum:
        return Colors.brown.shade400;
      case DrinkType.tequila:
      case DrinkType.mezcal:
        return Colors.orange.shade600;
      case DrinkType.liqueur:
        return Colors.purple.shade400;
      case DrinkType.wine:
        return Colors.red.shade400;
      case DrinkType.beer:
        return Colors.yellow.shade700;
      case DrinkType.cocktail:
        return Colors.pink.shade400;
      case DrinkType.other:
        return Colors.grey.shade600;
    }
  }

  IconData _getTypeIcon(DrinkType type) {
    switch (type) {
      case DrinkType.whiskey:
      case DrinkType.bourbon:
      case DrinkType.scotch:
        return Icons.local_bar;
      case DrinkType.vodka:
      case DrinkType.gin:
        return Icons.liquor;
      case DrinkType.rum:
        return Icons.local_drink;
      case DrinkType.tequila:
      case DrinkType.mezcal:
        return Icons.local_bar;
      case DrinkType.liqueur:
        return Icons.wine_bar;
      case DrinkType.wine:
        return Icons.wine_bar;
      case DrinkType.beer:
        return Icons.sports_bar;
      case DrinkType.cocktail:
        return Icons.local_bar;
      case DrinkType.other:
        return Icons.local_drink;
    }
  }

  String _getTypeDisplayName(DrinkType type) {
    switch (type) {
      case DrinkType.whiskey:
        return 'Whiskey';
      case DrinkType.bourbon:
        return 'Bourbon';
      case DrinkType.scotch:
        return 'Scotch';
      case DrinkType.vodka:
        return 'Vodka';
      case DrinkType.gin:
        return 'Gin';
      case DrinkType.rum:
        return 'Rum';
      case DrinkType.tequila:
        return 'Tequila';
      case DrinkType.mezcal:
        return 'Mezcal';
      case DrinkType.liqueur:
        return 'Liqueur';
      case DrinkType.wine:
        return 'Wine';
      case DrinkType.beer:
        return 'Beer';
      case DrinkType.cocktail:
        return 'Cocktail';
      case DrinkType.other:
        return 'Other';
    }
  }
}