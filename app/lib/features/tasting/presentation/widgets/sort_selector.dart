import 'package:flutter/material.dart';
import '../providers/tasting_providers.dart';

class SortSelector extends StatelessWidget {
  final SortBy sortBy;
  final SortDirection sortDirection;
  final Function(SortBy, SortDirection) onChanged;

  const SortSelector({
    super.key,
    required this.sortBy,
    required this.sortDirection,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            // Sort options
            ...SortBy.values.map((option) {
              return _buildSortOption(option);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(SortBy option) {
    final isSelected = sortBy == option;
    final optionData = _getSortOptionData(option);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          if (isSelected) {
            // Toggle direction if same option is selected
            final newDirection = sortDirection == SortDirection.ascending
                ? SortDirection.descending
                : SortDirection.ascending;
            onChanged(option, newDirection);
          } else {
            // Select new option with default direction
            onChanged(option, optionData.defaultDirection);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber.shade50 : null,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.amber.shade300 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                optionData.icon,
                size: 20,
                color: isSelected ? Colors.amber.shade700 : Colors.grey.shade600,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  optionData.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.amber.shade700 : Colors.grey.shade800,
                  ),
                ),
              ),
              if (isSelected) ...[
                Icon(
                  sortDirection == SortDirection.ascending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 18,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  sortDirection == SortDirection.ascending ? 'A-Z' : 'Z-A',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  SortOptionData _getSortOptionData(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.name:
        return SortOptionData(
          label: 'Name',
          icon: Icons.sort_by_alpha,
          defaultDirection: SortDirection.ascending,
        );
      case SortBy.abv:
        return SortOptionData(
          label: 'Alcohol Content (ABV)',
          icon: Icons.local_bar,
          defaultDirection: SortDirection.descending,
        );
      case SortBy.rating:
        return SortOptionData(
          label: 'Average Rating',
          icon: Icons.star,
          defaultDirection: SortDirection.descending,
        );
      case SortBy.created:
        return SortOptionData(
          label: 'Date Added',
          icon: Icons.access_time,
          defaultDirection: SortDirection.descending,
        );
      case SortBy.country:
        return SortOptionData(
          label: 'Country',
          icon: Icons.public,
          defaultDirection: SortDirection.ascending,
        );
    }
  }
}

class SortOptionData {
  final String label;
  final IconData icon;
  final SortDirection defaultDirection;

  SortOptionData({
    required this.label,
    required this.icon,
    required this.defaultDirection,
  });
}

// Quick sort buttons widget
class QuickSortButtons extends StatelessWidget {
  final SortBy currentSortBy;
  final SortDirection currentSortDirection;
  final Function(SortBy, SortDirection) onChanged;

  const QuickSortButtons({
    super.key,
    required this.currentSortBy,
    required this.currentSortDirection,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _buildQuickSortChip(
          'A-Z',
          Icons.sort_by_alpha,
          SortBy.name,
          SortDirection.ascending,
        ),
        _buildQuickSortChip(
          'Newest',
          Icons.new_releases,
          SortBy.created,
          SortDirection.descending,
        ),
        _buildQuickSortChip(
          'Highest ABV',
          Icons.local_bar,
          SortBy.abv,
          SortDirection.descending,
        ),
        _buildQuickSortChip(
          'Top Rated',
          Icons.star,
          SortBy.rating,
          SortDirection.descending,
        ),
      ],
    );
  }

  Widget _buildQuickSortChip(
    String label,
    IconData icon,
    SortBy sortBy,
    SortDirection direction,
  ) {
    final isSelected = currentSortBy == sortBy && currentSortDirection == direction;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onChanged(sortBy, direction);
        }
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.amber.shade200,
      checkmarkColor: Colors.amber.shade800,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? Colors.amber.shade800 : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}