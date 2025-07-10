import 'package:flutter/material.dart';
import '../../domain/entities/drink.dart';
import '../providers/tasting_providers.dart';

class FilterChipsDisplay extends StatelessWidget {
  final DrinksFilter filter;
  final Function(DrinksFilter) onFilterChanged;

  const FilterChipsDisplay({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activeChips = _buildActiveFilterChips();
    
    if (activeChips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters (${filter.activeFilterCount})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              if (filter.hasActiveFilters)
                TextButton(
                  onPressed: () => onFilterChanged(filter.clearAllFilters()),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.shade600,
                    minimumSize: const Size(0, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: activeChips,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveFilterChips() {
    final chips = <Widget>[];

    // Search filter
    if (filter.search != null && filter.search!.isNotEmpty) {
      chips.add(_buildFilterChip(
        label: 'Search: "${filter.search}"',
        icon: Icons.search,
        onRemove: () => onFilterChanged(filter.copyWith(search: null)),
      ));
    }

    // Type filter
    if (filter.type != null) {
      chips.add(_buildFilterChip(
        label: 'Type: ${_getTypeDisplayName(filter.type!)}',
        icon: Icons.local_bar,
        onRemove: () => onFilterChanged(filter.copyWith(type: null)),
      ));
    }

    // Multiple types filter
    if (filter.types != null && filter.types!.isNotEmpty) {
      chips.add(_buildFilterChip(
        label: 'Types: ${filter.types!.length} selected',
        icon: Icons.local_bar,
        onRemove: () => onFilterChanged(filter.copyWith(types: null)),
      ));
    }

    // ABV range filter
    if (filter.minAbv != null || filter.maxAbv != null) {
      final minAbv = filter.minAbv?.round() ?? 0;
      final maxAbv = filter.maxAbv?.round() ?? 100;
      chips.add(_buildFilterChip(
        label: 'ABV: $minAbv%-$maxAbv%',
        icon: Icons.percent,
        onRemove: () => onFilterChanged(filter.copyWith(
          minAbv: null,
          maxAbv: null,
        )),
      ));
    }

    // Country filter
    if (filter.country != null) {
      chips.add(_buildFilterChip(
        label: 'Country: ${filter.country}',
        icon: Icons.public,
        onRemove: () => onFilterChanged(filter.copyWith(country: null)),
      ));
    }

    // Multiple countries filter
    if (filter.countries != null && filter.countries!.isNotEmpty) {
      chips.add(_buildFilterChip(
        label: 'Countries: ${filter.countries!.length} selected',
        icon: Icons.public,
        onRemove: () => onFilterChanged(filter.copyWith(countries: null)),
      ));
    }

    // Rating filter
    if (filter.minRating != null || filter.maxRating != null) {
      final minRating = filter.minRating ?? 0;
      final maxRating = filter.maxRating ?? 5;
      chips.add(_buildFilterChip(
        label: 'Rating: ${minRating.toStringAsFixed(1)}-${maxRating.toStringAsFixed(1)}★',
        icon: Icons.star,
        onRemove: () => onFilterChanged(filter.copyWith(
          minRating: null,
          maxRating: null,
        )),
      ));
    }

    // Only rated filter
    if (filter.onlyRated == true) {
      chips.add(_buildFilterChip(
        label: 'Only Rated',
        icon: Icons.star_outline,
        onRemove: () => onFilterChanged(filter.copyWith(onlyRated: null)),
      ));
    }

    // Only unrated filter
    if (filter.onlyUnrated == true) {
      chips.add(_buildFilterChip(
        label: 'Only Unrated',
        icon: Icons.star_border,
        onRemove: () => onFilterChanged(filter.copyWith(onlyUnrated: null)),
      ));
    }

    // Sort filter (if not default)
    if (filter.sortBy != SortBy.created || filter.sortDirection != SortDirection.descending) {
      final sortLabel = _getSortDisplayName(filter.sortBy, filter.sortDirection);
      chips.add(_buildFilterChip(
        label: 'Sort: $sortLabel',
        icon: Icons.sort,
        onRemove: () => onFilterChanged(filter.copyWith(
          sortBy: SortBy.created,
          sortDirection: SortDirection.descending,
        )),
      ));
    }

    return chips;
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.amber.shade800,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber.shade800,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14,
              color: Colors.amber.shade800,
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

  String _getSortDisplayName(SortBy sortBy, SortDirection direction) {
    final directionText = direction == SortDirection.ascending ? 'A-Z' : 'Z-A';
    
    switch (sortBy) {
      case SortBy.name:
        return 'Name ($directionText)';
      case SortBy.abv:
        return 'ABV (${direction == SortDirection.ascending ? 'Low-High' : 'High-Low'})';
      case SortBy.rating:
        return 'Rating (${direction == SortDirection.ascending ? 'Low-High' : 'High-Low'})';
      case SortBy.created:
        return 'Date (${direction == SortDirection.ascending ? 'Oldest' : 'Newest'})';
      case SortBy.country:
        return 'Country ($directionText)';
    }
  }
}