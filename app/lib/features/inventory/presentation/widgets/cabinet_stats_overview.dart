import 'package:flutter/material.dart';
import '../../domain/entities/cabinet_stats.dart';

class CabinetStatsOverview extends StatelessWidget {
  final CabinetStats stats;
  
  const CabinetStatsOverview({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.bar_chart, color: Colors.amber, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Cabinet Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Main stats row
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Total Items',
                      stats.totalItems.toString(),
                      Icons.inventory,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Available',
                      stats.availableItems.toString(),
                      Icons.wine_bar,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Wishlist',
                      stats.wishlistItems.toString(),
                      Icons.favorite,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Additional stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Avg Fill',
                      '${stats.averageFillLevel.toStringAsFixed(0)}%',
                      Icons.battery_std,
                      _getFillLevelColor(stats.averageFillLevel),
                    ),
                  ),
                  if (stats.totalValue > 0) ...[
                    Expanded(
                      child: _buildStatItem(
                        'Value',
                        '\$${stats.totalValue.toStringAsFixed(0)}',
                        Icons.attach_money,
                        Colors.purple,
                      ),
                    ),
                  ],
                  if (stats.mostCollectedType != null) ...[
                    Expanded(
                      child: _buildStatItem(
                        'Top Type',
                        stats.mostCollectedType!,
                        Icons.category,
                        Colors.teal,
                      ),
                    ),
                  ],
                ],
              ),
              
              // Summary text
              if (stats.totalItems > 0) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getSummaryIcon(),
                        color: Colors.amber.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          stats.summaryDescription,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Color _getFillLevelColor(double fillLevel) {
    if (fillLevel >= 75) return Colors.green;
    if (fillLevel >= 50) return Colors.orange;
    if (fillLevel >= 25) return Colors.red;
    return Colors.grey;
  }
  
  IconData _getSummaryIcon() {
    if (stats.availableItems == 0) return Icons.warning;
    if (stats.isWellStocked) return Icons.check_circle;
    return Icons.info;
  }
}