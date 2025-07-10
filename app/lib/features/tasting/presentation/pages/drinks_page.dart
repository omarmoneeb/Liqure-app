import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/drink.dart';
import '../providers/tasting_providers.dart';

class DrinksPage extends ConsumerStatefulWidget {
  const DrinksPage({super.key});

  @override
  ConsumerState<DrinksPage> createState() => _DrinksPageState();
}

class _DrinksPageState extends ConsumerState<DrinksPage> {
  final TextEditingController _searchController = TextEditingController();
  DrinkType? _selectedType;
  String _searchQuery = '';
  
  // Memoized filter to prevent unnecessary rebuilds
  DrinksFilter? _cachedFilter;
  String? _lastSearchQuery;
  DrinkType? _lastSelectedType;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  DrinksFilter _getFilter() {
    // Check if we need to create a new filter
    if (_cachedFilter == null || 
        _lastSearchQuery != _searchQuery || 
        _lastSelectedType != _selectedType) {
      
      print('🎨 DrinksPage: Creating new filter (search: "$_searchQuery", type: $_selectedType)');
      
      _cachedFilter = DrinksFilter(
        search: _searchQuery.isEmpty ? null : _searchQuery,
        type: _selectedType,
      );
      _lastSearchQuery = _searchQuery;
      _lastSelectedType = _selectedType;
    } else {
      print('🎨 DrinksPage: Reusing cached filter');
    }
    
    return _cachedFilter ?? const DrinksFilter();
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 DrinksPage: Building with searchQuery="$_searchQuery", selectedType=$_selectedType');
    
    final filter = _getFilter();
    print('🎨 DrinksPage: Using filter: search=${filter.search}, type=${filter.type}');
    
    final drinksAsync = ref.watch(drinksProvider(filter));
    
    print('🎨 DrinksPage: Got drinksAsync state: ${drinksAsync.runtimeType}');
    
    drinksAsync.when(
      data: (drinks) => print('🎨 DrinksPage: Data state with ${drinks.length} drinks'),
      loading: () => print('🎨 DrinksPage: Loading state'),
      error: (error, stack) => print('🎨 DrinksPage: Error state: $error'),
    );

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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add drink page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add drink feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber.shade50,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search drinks...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                // Type Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTypeChip('All', null),
                      const SizedBox(width: 8),
                      ...DrinkType.values.map((type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildTypeChip(_getTypeDisplayName(type), type),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Drinks List
          Expanded(
            child: drinksAsync.when(
              data: (drinks) {
                if (drinks.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    final drink = drinks[index];
                    return _buildDrinkCard(drink);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading drinks: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(drinksProvider(filter)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, DrinkType? type) {
    final isSelected = _selectedType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
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
          print('🔍 DrinksPage: Navigating to drink detail with id="${drink.id}", name="${drink.name}"');
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
              // Rating (placeholder)
              Column(
                children: [
                  const Icon(Icons.star_border, color: Colors.amber),
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
            ],
          ),
        ),
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
            _searchQuery.isNotEmpty || _selectedType != null
                ? 'Try adjusting your search or filter'
                : 'Seed the database to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
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