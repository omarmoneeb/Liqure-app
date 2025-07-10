import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../tasting/domain/entities/drink.dart';
import '../../../tasting/presentation/providers/tasting_providers.dart';
import '../../domain/entities/user_statistics.dart';

class CollectionStatsCard extends ConsumerWidget {
  final UserStatistics statistics;
  final bool isLoading;

  const CollectionStatsCard({
    super.key,
    required this.statistics,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withValues(alpha: 0.1),
              Colors.indigo.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_bar,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Collection Insights',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            else if (!statistics.hasRatings)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.wine_bar_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No collection data yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  // Overview Stats
                  Column(
                    children: [
                      _buildClickableStatItem(
                        'Drinks Rated',
                        statistics.drinksRated.toString(),
                        Icons.wine_bar,
                        Colors.blue,
                        () {
                          ref.read(drinksFilterProvider.notifier).setOnlyRatedFilter();
                          context.go('/drinks');
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildClickableStatItem(
                        'Countries Explored',
                        statistics.uniqueCountries.toString(),
                        Icons.public,
                        Colors.green,
                        () {
                          if (statistics.favoriteCountry != null) {
                            ref.read(drinksFilterProvider.notifier).setCountryFilter(statistics.favoriteCountry!);
                          } else {
                            ref.read(drinksFilterProvider.notifier).resetFilter();
                          }
                          context.go('/drinks');
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildClickableStatItem(
                        'Types Tried',
                        statistics.typeBreakdown.length.toString(),
                        Icons.category,
                        Colors.orange,
                        () {
                          if (statistics.favoriteType != null) {
                            ref.read(drinksFilterProvider.notifier).setTypeFilter(statistics.favoriteType!);
                          } else {
                            ref.read(drinksFilterProvider.notifier).resetFilter();
                          }
                          context.go('/drinks');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Favorite Type and Country
                  if (statistics.favoriteType != null || statistics.favoriteCountry != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (statistics.favoriteType != null) ...[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Favorite Type',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        _getTypeIcon(statistics.favoriteType!),
                                        size: 16,
                                        color: _getTypeColor(statistics.favoriteType!),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _getTypeDisplayName(statistics.favoriteType!),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (statistics.favoriteType != null && statistics.favoriteCountry != null)
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey.shade300,
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          if (statistics.favoriteCountry != null) ...[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Favorite Country',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.flag,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        statistics.favoriteCountry!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 12),
                  
                  // Top Types List
                  if (statistics.typeBreakdown.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Types',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          'Ratings',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...statistics.typeBreakdown.entries
                        .take(3)
                        .map((entry) => _buildTypeBreakdownItem(entry.key, entry.value)),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildClickableStatItem(String label, String value, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBreakdownItem(DrinkType type, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            _getTypeIcon(type),
            size: 16,
            color: _getTypeColor(type),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getTypeDisplayName(type),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getTypeColor(type).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getTypeColor(type),
              ),
            ),
          ),
        ],
      ),
    );
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

  IconData _getTypeIcon(DrinkType type) {
    switch (type) {
      case DrinkType.whiskey:
      case DrinkType.bourbon:
      case DrinkType.scotch:
        return Icons.liquor;
      case DrinkType.vodka:
      case DrinkType.gin:
      case DrinkType.rum:
      case DrinkType.tequila:
      case DrinkType.mezcal:
      case DrinkType.liqueur:
        return Icons.wine_bar;
      case DrinkType.wine:
        return Icons.wine_bar;
      case DrinkType.beer:
        return Icons.sports_bar;
      case DrinkType.cocktail:
        return Icons.local_bar;
      case DrinkType.other:
        return Icons.local_bar;
    }
  }

  Color _getTypeColor(DrinkType type) {
    switch (type) {
      case DrinkType.whiskey:
        return Colors.brown.shade600;
      case DrinkType.bourbon:
        return Colors.brown.shade800;
      case DrinkType.scotch:
        return Colors.brown.shade700;
      case DrinkType.vodka:
        return Colors.blue.shade600;
      case DrinkType.gin:
        return Colors.green.shade600;
      case DrinkType.rum:
        return Colors.amber.shade700;
      case DrinkType.tequila:
        return Colors.orange.shade600;
      case DrinkType.mezcal:
        return Colors.grey.shade600;
      case DrinkType.liqueur:
        return Colors.purple.shade600;
      case DrinkType.wine:
        return Colors.red.shade600;
      case DrinkType.beer:
        return Colors.yellow.shade700;
      case DrinkType.cocktail:
        return Colors.pink.shade600;
      case DrinkType.other:
        return Colors.grey.shade500;
    }
  }
}