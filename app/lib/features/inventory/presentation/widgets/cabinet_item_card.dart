import 'package:flutter/material.dart';
import '../../domain/entities/cabinet_item.dart';

class CabinetItemCard extends StatelessWidget {
  final CabinetItem item;
  final VoidCallback? onTap;
  final Function(String action, CabinetItem item)? onAction;
  
  const CabinetItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status and action button
              Row(
                children: [
                  _buildStatusChip(),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (action) => onAction?.call(action, item),
                    itemBuilder: (context) => _buildActionMenuItems(),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Main content row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bottle icon with fill level indicator
                  _buildBottleIndicator(),
                  
                  const SizedBox(width: 16),
                  
                  // Item details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drink ID (will be replaced with actual drink name when integrated)
                        Text(
                          'Drink: ${item.drinkId.substring(0, 8)}...',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Location and quantity
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.displayLocation,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (item.quantity != null && item.quantity! > 1) ...[
                              const SizedBox(width: 8),
                              Text(
                                '×${item.quantity}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Purchase info or notes
                        if (item.purchasePrice != null) ...[
                          Text(
                            '\$${item.purchasePrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ] else if (item.personalNotes != null && item.personalNotes!.isNotEmpty) ...[
                          Text(
                            item.personalNotes!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        
                        // Tags
                        if (item.tags != null && item.tags!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            children: item.tags!.take(3).map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            )).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              
              // Fill level bar (for available items)
              if (item.status == CabinetStatus.available) ...[
                const SizedBox(height: 12),
                _buildFillLevelBar(),
              ],
              
              // Date information
              const SizedBox(height: 8),
              _buildDateInfo(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusChip() {
    Color color;
    IconData icon;
    
    switch (item.status) {
      case CabinetStatus.available:
        color = item.fillLevel > 0 ? Colors.green : Colors.orange;
        icon = item.fillLevel > 0 ? Icons.wine_bar : Icons.battery_alert;
        break;
      case CabinetStatus.empty:
        color = Colors.grey;
        icon = Icons.remove_circle_outline;
        break;
      case CabinetStatus.wishlist:
        color = Colors.orange;
        icon = Icons.favorite_border;
        break;
      case CabinetStatus.discontinued:
        color = Colors.red;
        icon = Icons.block;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            item.statusDisplayText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottleIndicator() {
    final color = _getFillLevelColor(item.fillLevel);
    
    return Container(
      width: 40,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          // Empty space (top of bottle)
          Expanded(
            flex: (100 - item.fillLevel).round(),
            child: Container(),
          ),
          // Filled space
          if (item.fillLevel > 0)
            Expanded(
              flex: item.fillLevel,
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(2),
                    bottomRight: Radius.circular(2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildFillLevelBar() {
    final color = _getFillLevelColor(item.fillLevel);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              item.fillLevelDescription,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const Spacer(),
            Text(
              '${item.fillLevel}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: item.fillLevel / 100,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
  
  Widget _buildDateInfo() {
    String dateText;
    IconData icon;
    Color color = Colors.grey.shade600;
    
    if (item.status == CabinetStatus.wishlist) {
      dateText = 'Added ${_formatDate(item.addedAt)}';
      icon = Icons.favorite_border;
    } else if (item.finishedDate != null) {
      dateText = 'Finished ${_formatDate(item.finishedDate!)}';
      icon = Icons.done;
    } else if (item.openedDate != null) {
      dateText = 'Opened ${_formatDate(item.openedDate!)}';
      icon = Icons.open_in_new;
    } else if (item.purchaseDate != null) {
      dateText = 'Purchased ${_formatDate(item.purchaseDate!)}';
      icon = Icons.shopping_cart;
    } else {
      dateText = 'Added ${_formatDate(item.addedAt)}';
      icon = Icons.add_circle_outline;
    }
    
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          dateText,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }
  
  List<PopupMenuEntry<String>> _buildActionMenuItems() {
    final actions = <PopupMenuEntry<String>>[];
    
    switch (item.status) {
      case CabinetStatus.available:
        if (item.openedDate == null) {
          actions.add(const PopupMenuItem(
            value: 'mark_opened',
            child: Row(
              children: [
                Icon(Icons.open_in_new, size: 18),
                SizedBox(width: 8),
                Text('Mark as Opened'),
              ],
            ),
          ));
        }
        
        actions.add(const PopupMenuItem(
          value: 'update_fill_level',
          child: Row(
            children: [
              Icon(Icons.battery_std, size: 18),
              SizedBox(width: 8),
              Text('Update Fill Level'),
            ],
          ),
        ));
        
        actions.add(const PopupMenuItem(
          value: 'mark_finished',
          child: Row(
            children: [
              Icon(Icons.done, size: 18),
              SizedBox(width: 8),
              Text('Mark as Finished'),
            ],
          ),
        ));
        
        actions.add(const PopupMenuItem(
          value: 'move_to_wishlist',
          child: Row(
            children: [
              Icon(Icons.favorite, size: 18),
              SizedBox(width: 8),
              Text('Move to Wishlist'),
            ],
          ),
        ));
        break;
        
      case CabinetStatus.wishlist:
        actions.add(const PopupMenuItem(
          value: 'mark_purchased',
          child: Row(
            children: [
              Icon(Icons.shopping_cart, size: 18),
              SizedBox(width: 8),
              Text('Mark as Purchased'),
            ],
          ),
        ));
        break;
        
      case CabinetStatus.empty:
        actions.add(const PopupMenuItem(
          value: 'repurchase',
          child: Row(
            children: [
              Icon(Icons.refresh, size: 18),
              SizedBox(width: 8),
              Text('Buy Again'),
            ],
          ),
        ));
        break;
        
      default:
        break;
    }
    
    // Common actions
    actions.add(const PopupMenuItem(
      value: 'edit',
      child: Row(
        children: [
          Icon(Icons.edit, size: 18),
          SizedBox(width: 8),
          Text('Edit Details'),
        ],
      ),
    ));
    
    actions.add(const PopupMenuItem(
      value: 'remove',
      child: Row(
        children: [
          Icon(Icons.delete, size: 18, color: Colors.red),
          SizedBox(width: 8),
          Text('Remove', style: TextStyle(color: Colors.red)),
        ],
      ),
    ));
    
    return actions;
  }
  
  Color _getFillLevelColor(int fillLevel) {
    if (fillLevel >= 75) return Colors.green;
    if (fillLevel >= 50) return Colors.orange;
    if (fillLevel >= 25) return Colors.red;
    return Colors.grey;
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks} week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months} month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years} year${years == 1 ? '' : 's'} ago';
    }
  }
}