import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/drink.dart';
import '../../domain/entities/rating.dart';
import '../providers/tasting_providers.dart';
import '../widgets/rating_widget.dart';
import '../widgets/rating_submission_dialog.dart';
import '../../../inventory/domain/entities/cabinet_item.dart';
import '../../../inventory/presentation/providers/cabinet_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DrinkDetailPage extends ConsumerStatefulWidget {
  final String drinkId;

  const DrinkDetailPage({super.key, required this.drinkId});

  @override
  ConsumerState<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends ConsumerState<DrinkDetailPage> {
  final bool _isAddingToCabinet = false;
  
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('🔍 DrinkDetailPage: Building with drinkId="${widget.drinkId}"');
    }
    
    final drinkAsync = ref.watch(drinkByIdProvider(widget.drinkId));
    final userRatingAsync = ref.watch(userDrinkRatingProvider(widget.drinkId));
    final averageRatingAsync = ref.watch(drinkAverageRatingProvider(widget.drinkId));
    
    if (kDebugMode) {
      drinkAsync.when(
        data: (drink) => debugPrint('🔍 DrinkDetailPage: Got drink data: ${drink?.id} - ${drink?.name}'),
        loading: () => debugPrint('🔍 DrinkDetailPage: Loading drink...'),
        error: (error, stack) => debugPrint('🔍 DrinkDetailPage: Error loading drink: $error'),
      );
    }

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

          final cabinetItem = ref.watch(cabinetItemByDrinkProvider(drink.id));
          // Get similar drinks by filtering drinks of the same type
          final similarDrinksAsync = ref.watch(drinksProvider(DrinksFilter(types: [drink.type])));
          
          return CustomScrollView(
            slivers: [
              // App Bar with image carousel
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                backgroundColor: _getTypeColor(drink.type),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/drinks'),
                ),
                actions: [
                  // Add to Cabinet Button
                  cabinetItem.when(
                    data: (item) {
                      if (item != null) {
                        return IconButton(
                          icon: Icon(
                            item.isWishlist ? Icons.favorite_border : Icons.favorite,
                            color: Colors.white,
                          ),
                          onPressed: () => context.go('/cabinet'),
                          tooltip: 'View in Cabinet',
                        );
                      }
                      return IconButton(
                        icon: Icon(
                          _isAddingToCabinet ? Icons.hourglass_empty : Icons.add_circle_outline,
                          color: Colors.white,
                        ),
                        onPressed: _isAddingToCabinet ? null : () => _showAddToCabinetDialog(context, drink),
                        tooltip: 'Add to Cabinet',
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
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
                  background: Stack(
                    children: [
                      // Image carousel or hero animation
                      drink.image != null && drink.image!.isNotEmpty
                          ? Hero(
                              tag: 'drink-${drink.id}',
                              child: CachedNetworkImage(
                                imageUrl: drink.image!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: _getTypeColor(drink.type),
                                  child: const Center(
                                    child: CircularProgressIndicator(color: Colors.white),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: _getTypeColor(drink.type),
                                  child: Icon(
                                    _getTypeIcon(drink.type),
                                    size: 120,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            )
                          : Hero(
                              tag: 'drink-${drink.id}',
                              child: Container(
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
                      // Gradient overlay for better text visibility
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      
                      // Similar Drinks Section
                      if (similarDrinksAsync.hasValue && similarDrinksAsync.value!.isNotEmpty) ...[  
                        const SizedBox(height: 32),
                        const Text(
                          'Similar Drinks',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarDrinksAsync.value!.where((d) => d.id != drink.id).take(10).length,
                            itemBuilder: (context, index) {
                              final similarDrink = similarDrinksAsync.value!.where((d) => d.id != drink.id).toList()[index];
                              return _buildSimilarDrinkCard(similarDrink);
                            },
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
                onPressed: () {
                  ref.refresh(drinkByIdProvider(widget.drinkId));
                },
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
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              
              navigator.pop();
              try {
                await ref.read(ratingNotifierProvider.notifier).deleteRating(ratingId);
                
                // Refresh the rating data
                ref.refresh(userDrinkRatingProvider(widget.drinkId));
                ref.refresh(drinkAverageRatingProvider(widget.drinkId));
                ref.refresh(drinkRatingsProvider(widget.drinkId));
                
                if (mounted) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Rating deleted!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(
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
  
  Widget _buildSimilarDrinkCard(Drink drink) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () => context.go('/drinks/${drink.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or icon
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: _getTypeColor(drink.type),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: drink.image != null && drink.image!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: drink.image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 100,
                            placeholder: (context, url) => Icon(
                              _getTypeIcon(drink.type),
                              size: 40,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              _getTypeIcon(drink.type),
                              size: 40,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        )
                      : Icon(
                          _getTypeIcon(drink.type),
                          size: 40,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                ),
              ),
              // Info - wrapped in Expanded to prevent overflow
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          drink.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (drink.abv != null)
                        Text(
                          '${drink.abv}% ABV',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddToCabinetDialog(BuildContext context, Drink drink) {
    showDialog(
      context: context,
      builder: (context) => _AddToCabinetDialog(drink: drink),
    ).then((_) {
      // Refresh cabinet item status
      ref.refresh(cabinetItemByDrinkProvider(drink.id));
    });
  }
}

// Add to Cabinet Dialog
class _AddToCabinetDialog extends ConsumerStatefulWidget {
  final Drink drink;
  
  const _AddToCabinetDialog({required this.drink});
  
  @override
  ConsumerState<_AddToCabinetDialog> createState() => _AddToCabinetDialogState();
}

class _AddToCabinetDialogState extends ConsumerState<_AddToCabinetDialog> {
  CabinetStatus _selectedStatus = CabinetStatus.available;
  StorageLocation _selectedLocation = StorageLocation.mainShelf;
  String? _customLocation;
  double? _purchasePrice;
  String? _purchaseStore;
  String? _notes;
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return AlertDialog(
      title: Text('Add "${widget.drink.name}" to Cabinet'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status selection
              const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<CabinetStatus>(
                selected: {_selectedStatus},
                onSelectionChanged: (Set<CabinetStatus> selection) {
                  setState(() {
                    _selectedStatus = selection.first;
                  });
                },
                segments: const [
                  ButtonSegment(
                    value: CabinetStatus.available,
                    label: Text('Have it'),
                    icon: Icon(Icons.check_circle),
                  ),
                  ButtonSegment(
                    value: CabinetStatus.wishlist,
                    label: Text('Want it'),
                    icon: Icon(Icons.favorite_border),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Location selection (only for available items)
              if (_selectedStatus == CabinetStatus.available) ...[
                const Text('Storage Location', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<StorageLocation>(
                  value: _selectedLocation,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: StorageLocation.values.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(_getLocationDisplayName(location)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value!;
                    });
                  },
                ),
                if (_selectedLocation == StorageLocation.other) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Custom Location',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _customLocation = value,
                    validator: (value) {
                      if (_selectedLocation == StorageLocation.other && 
                          (value == null || value.isEmpty)) {
                        return 'Please specify location';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),
                
                // Purchase info
                const Text('Purchase Information (Optional)', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          prefixText: r'$',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            _purchasePrice = double.tryParse(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Store',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _purchaseStore = value,
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onSaved: (value) => _notes = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: authState.isAuthenticated ? () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              
              // Capture context references before async operations
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final router = GoRouter.of(context);
              
              // Create cabinet item
              final now = DateTime.now();
              final cabinetItem = CabinetItem(
                id: _uuid.v4(), // Generate proper UUID
                drinkId: widget.drink.id,
                userId: authState.user!.id,
                status: _selectedStatus,
                addedAt: now,
                purchaseDate: _selectedStatus == CabinetStatus.available ? now : null,
                location: _selectedLocation,
                customLocation: _customLocation,
                quantity: 1,
                purchasePrice: _purchasePrice,
                purchaseStore: _purchaseStore,
                personalNotes: _notes,
                fillLevel: _selectedStatus == CabinetStatus.available ? 100 : 0,
                createdAt: now,
                updatedAt: now,
              );
              
              try {
                await ref.read(cabinetNotifierProvider.notifier).addToCabinet(cabinetItem);
                refreshCabinetData(ref);
                
                if (mounted) {
                  navigator.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        _selectedStatus == CabinetStatus.wishlist
                            ? 'Added to wishlist!'
                            : 'Added to cabinet!',
                      ),
                      backgroundColor: Colors.green,
                      action: SnackBarAction(
                        label: 'View',
                        textColor: Colors.white,
                        onPressed: () => router.go('/cabinet'),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
          } : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
  
  String _getLocationDisplayName(StorageLocation location) {
    switch (location) {
      case StorageLocation.mainShelf:
        return 'Main Shelf';
      case StorageLocation.topShelf:
        return 'Top Shelf';
      case StorageLocation.bottomShelf:
        return 'Bottom Shelf';
      case StorageLocation.cabinet:
        return 'Cabinet';
      case StorageLocation.cellar:
        return 'Cellar';
      case StorageLocation.bar:
        return 'Bar';
      case StorageLocation.kitchen:
        return 'Kitchen';
      case StorageLocation.other:
        return 'Other';
    }
  }
}