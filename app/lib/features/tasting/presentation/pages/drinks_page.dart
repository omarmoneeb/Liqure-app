import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/drink.dart';
import '../providers/tasting_providers.dart';
import '../widgets/enhanced_search_bar.dart';
import '../widgets/abv_range_slider.dart';
import '../widgets/country_filter.dart';
import '../widgets/sort_selector.dart';
import '../widgets/filter_chips.dart';
import '../widgets/rating_filter.dart';

class DrinksPage extends ConsumerStatefulWidget {
  const DrinksPage({super.key, this.barcodeQuery});
  
  final String? barcodeQuery;

  @override
  ConsumerState<DrinksPage> createState() => _DrinksPageState();
}

class _DrinksPageState extends ConsumerState<DrinksPage> {
  // Enhanced filter state
  DrinksFilter _currentFilter = const DrinksFilter();
  bool _showAdvancedFilters = false;
  final ScrollController _scrollController = ScrollController();

  // Available countries (will be populated from data)
  List<String> _availableCountries = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableCountries();
    
    // Check for shared filter state after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sharedFilter = ref.read(drinksFilterProvider);
      if (sharedFilter != const DrinksFilter()) {
        setState(() {
          _currentFilter = sharedFilter;
        });
        // Reset the shared filter after applying it
        ref.read(drinksFilterProvider.notifier).resetFilter();
      }
      
      // Handle barcode query parameter
      if (widget.barcodeQuery != null && widget.barcodeQuery!.isNotEmpty) {
        setState(() {
          _currentFilter = _currentFilter.copyWith(
            search: widget.barcodeQuery,
            searchFields: [SearchField.barcode], // Search specifically by barcode
          );
        });
        
        // Show a helpful message about barcode search
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Searching for barcode: ${widget.barcodeQuery}'),
            backgroundColor: Colors.amber,
            action: SnackBarAction(
              label: 'Clear',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  _currentFilter = _currentFilter.copyWith(
                    search: '',
                    searchFields: [SearchField.name], // Reset to name search
                  );
                });
              },
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadAvailableCountries() {
    // For now, use a predefined list. In production, this could be loaded from the backend
    _availableCountries = [
      'Scotland', 'Ireland', 'USA', 'Japan', 'France', 'Mexico', 
      'Russia', 'England', 'Canada', 'Germany', 'Italy', 'Spain',
      'Australia', 'India', 'Brazil', 'Argentina', 'Chile'
    ];
  }

  void _updateFilter(DrinksFilter newFilter) {
    setState(() {
      _currentFilter = newFilter;
    });
    if (kDebugMode) {
      debugPrint('🎨 Enhanced DrinksPage: Filter updated - activeFilters=${newFilter.activeFilterCount}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('🎨 Enhanced DrinksPage: Building with filter: ${_currentFilter.activeFilterCount} active filters');
    }
    
    final drinksAsync = ref.watch(drinksProvider(_currentFilter));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drinks'),
        backgroundColor: Colors.amber,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          // Scan barcode button
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              context.go('/scan');
            },
            tooltip: 'Scan Barcode',
          ),
          // Advanced filter toggle
          IconButton(
            icon: Icon(
              _showAdvancedFilters ? Icons.filter_list : Icons.filter_list_outlined,
              color: _showAdvancedFilters ? Colors.white : null,
            ),
            onPressed: () {
              setState(() {
                _showAdvancedFilters = !_showAdvancedFilters;
              });
            },
            tooltip: 'Advanced Filters',
          ),
          // Add drink button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add drink feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Enhanced Search Section (Fixed at top)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber.shade50,
            child: Column(
              children: [
                // Enhanced Search Bar
                EnhancedSearchBar(
                  searchQuery: _currentFilter.search,
                  searchFields: _currentFilter.searchFields,
                  onSearchChanged: (search) {
                    _updateFilter(_currentFilter.copyWith(search: search));
                  },
                  onSearchFieldsChanged: (fields) {
                    _updateFilter(_currentFilter.copyWith(searchFields: fields));
                  },
                  searchSuggestions: _getSearchSuggestions(),
                ),
                
                const SizedBox(height: 12),
                
                // Quick type filter chips (always visible)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickTypeChip('All', null),
                      const SizedBox(width: 8),
                      ...DrinkType.values.take(6).map((type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildQuickTypeChip(_getTypeDisplayName(type), type),
                      )),
                      if (!_showAdvancedFilters)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showAdvancedFilters = true;
                              });
                            },
                            icon: const Icon(Icons.tune, size: 16),
                            label: const Text('More Filters'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.amber.shade700,
                              side: BorderSide(color: Colors.amber.shade300),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Active Filters Display
                  if (_currentFilter.hasActiveFilters)
                    FilterChipsDisplay(
                      filter: _currentFilter,
                      onFilterChanged: _updateFilter,
                    ),
                  
                  // Advanced Filters Panel
                  if (_showAdvancedFilters)
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey.shade50,
                      child: Column(
                        children: [
                          // ABV Range Filter
                          ABVRangeSlider(
                            minValue: _currentFilter.minAbv,
                            maxValue: _currentFilter.maxAbv,
                            onChanged: (min, max) {
                              print('🍺 DrinksPage: ABV filter changed to min=$min, max=$max');
                              _updateFilter(_currentFilter.copyWith(
                                minAbv: min,
                                maxAbv: max,
                              ));
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Country Filter
                          CountryFilter(
                            selectedCountries: _currentFilter.countries,
                            availableCountries: _availableCountries,
                            onChanged: (countries) {
                              _updateFilter(_currentFilter.copyWith(countries: countries));
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Rating Filter
                          RatingFilter(
                            minRating: _currentFilter.minRating,
                            maxRating: _currentFilter.maxRating,
                            onlyRated: _currentFilter.onlyRated,
                            onlyUnrated: _currentFilter.onlyUnrated,
                            onChanged: (minRating, maxRating, onlyRated, onlyUnrated) {
                              _updateFilter(_currentFilter.copyWith(
                                minRating: minRating,
                                maxRating: maxRating,
                                onlyRated: onlyRated,
                                onlyUnrated: onlyUnrated,
                              ));
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Sort Selector
                          SortSelector(
                            sortBy: _currentFilter.sortBy,
                            sortDirection: _currentFilter.sortDirection,
                            onChanged: (sortBy, direction) {
                              _updateFilter(_currentFilter.copyWith(
                                sortBy: sortBy,
                                sortDirection: direction,
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                  
                  // Results Summary
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: drinksAsync.when(
                      data: (drinks) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${drinks.length} drink${drinks.length != 1 ? 's' : ''} found',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Remove duplicate Clear All button - it's already in FilterChipsDisplay
                        ],
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  
                  // Drinks List Container
                  Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: drinksAsync.when(
                      data: (drinks) {
                        if (drinks.isEmpty) {
                          return _buildEmptyState();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: drinks.length,
                          itemBuilder: (context, index) {
                            final drink = drinks[index];
                            return _buildDrinkCard(drink);
                          },
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text('Error loading drinks: $error'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => ref.refresh(drinksProvider(_currentFilter)),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for the enhanced UI
  List<String> _getSearchSuggestions() {
    // In production, this could be based on popular searches or existing drink names
    return [
      'Whiskey', 'Single Malt', 'Bourbon', 'Scotch', 'Japanese',
      'Highland', 'Speyside', 'Islay', 'Sherry Cask', 'Peated'
    ];
  }

  Widget _buildQuickTypeChip(String label, DrinkType? type) {
    final isSelected = _currentFilter.type == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        _updateFilter(_currentFilter.copyWith(type: selected ? type : null));
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.amber.shade200,
      checkmarkColor: Colors.amber.shade800,
      labelStyle: TextStyle(
        color: isSelected ? Colors.amber.shade800 : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildDrinkCard(Drink drink) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (kDebugMode) {
            debugPrint('🔍 DrinksPage: Navigating to drink detail with id="${drink.id}", name="${drink.name}"');
          }
          context.go('/drinks/${drink.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drink Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getTypeColor(drink.type),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(drink.type),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Drink Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drink.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTypeColor(drink.type).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getTypeDisplayName(drink.type),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getTypeColor(drink.type),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${drink.abv}% ABV',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      drink.country ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (drink.description != null && drink.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        drink.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Rating display
              _buildRatingDisplay(drink.id),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingDisplay(String drinkId) {
    final averageRatingAsync = ref.watch(drinkAverageRatingProvider(drinkId));
    
    return averageRatingAsync.when(
      data: (averageRating) {
        if (averageRating == null) {
          // No ratings
          return Column(
            children: [
              const Icon(Icons.star_border, color: Colors.grey),
              const SizedBox(height: 4),
              Text(
                '-',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          );
        } else {
          // Has rating
          return Column(
            children: [
              Icon(
                averageRating >= 4.0 ? Icons.star : Icons.star_half,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }
      },
      loading: () => Column(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '...',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
      error: (_, __) => Column(
        children: [
          const Icon(Icons.star_border, color: Colors.grey),
          const SizedBox(height: 4),
          Text(
            '-',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wine_bar_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No drinks found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentFilter.hasActiveFilters
                ? 'Try adjusting your filters or search terms'
                : 'Seed the database to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
          if (_currentFilter.hasActiveFilters) ...[
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentFilter = const DrinksFilter();
                });
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear All Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.go('/scan');
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Barcode'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    context.go('/debug');
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Seed Database'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.amber.shade700,
                    side: BorderSide(color: Colors.amber.shade300),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getTypeDisplayName(DrinkType type) {
    switch (type) {
      case DrinkType.whiskey:
        return 'Whiskey';
      case DrinkType.vodka:
        return 'Vodka';
      case DrinkType.gin:
        return 'Gin';
      case DrinkType.rum:
        return 'Rum';
      case DrinkType.tequila:
        return 'Tequila';
      case DrinkType.bourbon:
        return 'Bourbon';
      case DrinkType.scotch:
        return 'Scotch';
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

  Color _getTypeColor(DrinkType type) {
    switch (type) {
      case DrinkType.whiskey:
        return Colors.brown.shade600;
      case DrinkType.vodka:
        return Colors.blue.shade600;
      case DrinkType.gin:
        return Colors.green.shade600;
      case DrinkType.rum:
        return Colors.amber.shade700;
      case DrinkType.tequila:
        return Colors.orange.shade600;
      case DrinkType.bourbon:
        return Colors.brown.shade800;
      case DrinkType.scotch:
        return Colors.brown.shade700;
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
}