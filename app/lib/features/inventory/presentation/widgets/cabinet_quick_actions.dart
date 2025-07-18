import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cabinet_providers.dart';

class CabinetQuickActions extends ConsumerWidget {
  const CabinetQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lowFillItemsAsync = ref.watch(lowFillLevelItemsProvider);
    final recentItemsAsync = ref.watch(recentlyAddedItemsProvider);
    
    return Card(
      elevation: 1,
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
                Icon(Icons.flash_on, color: Colors.purple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Action buttons row
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Scan & Add',
                    Icons.qr_code_scanner,
                    Colors.amber,
                    () => context.go('/scan'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Browse Drinks',
                    Icons.search,
                    Colors.blue,
                    () => context.go('/drinks'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Locations',
                    Icons.location_on,
                    Colors.green,
                    () {
                      // TODO: Navigate to locations view
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Location view coming soon!')),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            // Notifications/alerts
            const SizedBox(height: 12),
            _buildNotifications(context, lowFillItemsAsync, recentItemsAsync),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNotifications(
    BuildContext context,
    AsyncValue lowFillItemsAsync,
    AsyncValue recentItemsAsync,
  ) {
    final notifications = <Widget>[];
    
    // Low fill level notification
    lowFillItemsAsync.whenData((lowFillItems) {
      if (lowFillItems.isNotEmpty) {
        notifications.add(
          _buildNotificationItem(
            icon: Icons.battery_alert,
            color: Colors.orange,
            title: 'Low Fill Levels',
            subtitle: '${lowFillItems.length} bottle${lowFillItems.length == 1 ? '' : 's'} running low',
            onTap: () {
              // TODO: Navigate to low fill items view
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${lowFillItems.length} bottles running low'),
                  action: SnackBarAction(
                    label: 'View',
                    onPressed: () {
                      // TODO: Show filtered view
                    },
                  ),
                ),
              );
            },
          ),
        );
      }
    });
    
    // Recent additions notification
    recentItemsAsync.whenData((recentItems) {
      if (recentItems.isNotEmpty) {
        final recentCount = recentItems.where((item) {
          final daysSinceAdded = DateTime.now().difference(item.addedAt).inDays;
          return daysSinceAdded <= 7; // Items added in last week
        }).length;
        
        if (recentCount > 0) {
          notifications.add(
            _buildNotificationItem(
              icon: Icons.new_releases,
              color: Colors.green,
              title: 'Recent Additions',
              subtitle: '$recentCount new item${recentCount == 1 ? '' : 's'} this week',
              onTap: () {
                // TODO: Navigate to recent items view
              },
            ),
          );
        }
      }
    });
    
    if (notifications.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      children: notifications
          .map((notification) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: notification,
              ))
          .toList(),
    );
  }
  
  Widget _buildNotificationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                size: 16,
                color: color.withOpacity(0.6),
              ),
          ],
        ),
      ),
    );
  }
}