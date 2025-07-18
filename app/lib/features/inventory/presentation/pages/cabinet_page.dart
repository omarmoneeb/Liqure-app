import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/cabinet_item.dart';
import '../providers/cabinet_providers.dart';
import '../widgets/cabinet_stats_overview.dart';
import '../widgets/cabinet_item_card.dart';
import '../widgets/cabinet_quick_actions.dart';

class CabinetPage extends ConsumerStatefulWidget {
  const CabinetPage({super.key});

  @override
  ConsumerState<CabinetPage> createState() => _CabinetPageState();
}

class _CabinetPageState extends ConsumerState<CabinetPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cabinetStatsAsync = ref.watch(cabinetStatsProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Cabinet'),
        backgroundColor: Colors.amber,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMenuOptions(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Available', icon: Icon(Icons.wine_bar, size: 20)),
            Tab(text: 'Wishlist', icon: Icon(Icons.favorite_border, size: 20)),
            Tab(text: 'Empty', icon: Icon(Icons.remove_circle_outline, size: 20)),
            Tab(text: 'All', icon: Icon(Icons.grid_view, size: 20)),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshCabinetData(ref);
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAvailableTab(),
            _buildWishlistTab(),
            _buildEmptyTab(),
            _buildAllItemsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddItemOptions(context);
        },
        backgroundColor: Colors.amber,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
  
  Widget _buildAvailableTab() {
    final availableItemsAsync = ref.watch(availableCabinetItemsProvider);
    final cabinetStatsAsync = ref.watch(cabinetStatsProvider);
    
    return availableItemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return _buildEmptyStateWithHeader(
            cabinetStatsAsync: cabinetStatsAsync,
            icon: Icons.wine_bar_outlined,
            title: 'No Available Items',
            subtitle: 'Add drinks to your cabinet to see them here',
            actionText: 'Add Your First Drink',
            onAction: () => _showAddItemOptions(context),
          );
        }
        
        return _buildItemsListWithHeader(items, cabinetStatsAsync);
      },
      loading: () => _buildLoadingListWithHeader(cabinetStatsAsync),
      error: (error, stack) => _buildErrorStateWithHeader(error, cabinetStatsAsync),
    );
  }
  
  Widget _buildWishlistTab() {
    final wishlistItemsAsync = ref.watch(wishlistItemsProvider);
    final cabinetStatsAsync = ref.watch(cabinetStatsProvider);
    
    return wishlistItemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return _buildEmptyStateWithHeader(
            cabinetStatsAsync: cabinetStatsAsync,
            icon: Icons.favorite_border_outlined,
            title: 'No Wishlist Items',
            subtitle: 'Add drinks you want to your wishlist',
            actionText: 'Add to Wishlist',
            onAction: () => _showAddItemOptions(context),
          );
        }
        
        return _buildItemsListWithHeader(items, cabinetStatsAsync);
      },
      loading: () => _buildLoadingListWithHeader(cabinetStatsAsync),
      error: (error, stack) => _buildErrorStateWithHeader(error, cabinetStatsAsync),
    );
  }
  
  Widget _buildEmptyTab() {
    final emptyItemsAsync = ref.watch(emptyItemsProvider);
    final cabinetStatsAsync = ref.watch(cabinetStatsProvider);
    
    return emptyItemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return _buildEmptyStateWithHeader(
            cabinetStatsAsync: cabinetStatsAsync,
            icon: Icons.check_circle_outline,
            title: 'No Empty Bottles',
            subtitle: 'Bottles you finish will appear here',
            actionText: null,
            onAction: null,
          );
        }
        
        return _buildItemsListWithHeader(items, cabinetStatsAsync);
      },
      loading: () => _buildLoadingListWithHeader(cabinetStatsAsync),
      error: (error, stack) => _buildErrorStateWithHeader(error, cabinetStatsAsync),
    );
  }
  
  Widget _buildAllItemsTab() {
    final allItemsAsync = ref.watch(cabinetItemsProvider);
    final cabinetStatsAsync = ref.watch(cabinetStatsProvider);
    
    return allItemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return _buildEmptyStateWithHeader(
            cabinetStatsAsync: cabinetStatsAsync,
            icon: Icons.inventory_outlined,
            title: 'Cabinet is Empty',
            subtitle: 'Start building your spirits collection',
            actionText: 'Add Your First Item',
            onAction: () => _showAddItemOptions(context),
          );
        }
        
        return _buildItemsListWithHeader(items, cabinetStatsAsync);
      },
      loading: () => _buildLoadingListWithHeader(cabinetStatsAsync),
      error: (error, stack) => _buildErrorStateWithHeader(error, cabinetStatsAsync),
    );
  }
  
  Widget _buildItemsList(List<CabinetItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Add bottom padding for FAB
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CabinetItemCard(
            item: items[index],
            onTap: () => _showItemDetails(context, items[index]),
            onAction: (action, item) => _handleItemAction(action, item),
          ),
        );
      },
    );
  }

  Widget _buildItemsListWithHeader(List<CabinetItem> items, AsyncValue cabinetStatsAsync) {
    return CustomScrollView(
      slivers: [
        // Header with stats and quick actions
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Stats Overview
              cabinetStatsAsync.when(
                data: (stats) => CabinetStatsOverview(stats: stats),
                loading: () => _buildLoadingStats(),
                error: (error, stack) => _buildErrorStats(error),
              ),
              
              // Quick Actions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CabinetQuickActions(),
              ),
            ],
          ),
        ),
        
        // Items list
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // Add bottom padding for FAB
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CabinetItemCard(
                    item: items[index],
                    onTap: () => _showItemDetails(context, items[index]),
                    onAction: (action, item) => _handleItemAction(action, item),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
            // Add bottom padding to account for floating action button
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateWithHeader({
    required AsyncValue cabinetStatsAsync,
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return CustomScrollView(
      slivers: [
        // Header with stats and quick actions
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Stats Overview
              cabinetStatsAsync.when(
                data: (stats) => CabinetStatsOverview(stats: stats),
                loading: () => _buildLoadingStats(),
                error: (error, stack) => _buildErrorStats(error),
              ),
              
              // Quick Actions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CabinetQuickActions(),
              ),
            ],
          ),
        ),
        
        // Empty state content
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (actionText != null && onAction != null) ...[
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: onAction,
                      icon: const Icon(Icons.add),
                      label: Text(actionText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                  // Add bottom padding to account for floating action button
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingListWithHeader(AsyncValue cabinetStatsAsync) {
    return CustomScrollView(
      slivers: [
        // Header with stats and quick actions
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Stats Overview
              cabinetStatsAsync.when(
                data: (stats) => CabinetStatsOverview(stats: stats),
                loading: () => _buildLoadingStats(),
                error: (error, stack) => _buildErrorStats(error),
              ),
              
              // Quick Actions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CabinetQuickActions(),
              ),
            ],
          ),
        ),
        
        // Loading content
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 16,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 14,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 12,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: 5,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildLoadingStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: List.generate(3, (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                child: Column(
                  children: [
                    Container(
                      height: 24,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 16,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
  
  Widget _buildErrorState(dynamic error) {
    // Extract meaningful error message
    String errorMessage = _getReadableErrorMessage(error);
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading cabinet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 150),
              child: SingleChildScrollView(
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => refreshCabinetData(ref),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorStateWithHeader(dynamic error, AsyncValue cabinetStatsAsync) {
    // Extract meaningful error message
    String errorMessage = _getReadableErrorMessage(error);
    
    return CustomScrollView(
      slivers: [
        // Header with stats and quick actions
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Stats Overview
              cabinetStatsAsync.when(
                data: (stats) => CabinetStatsOverview(stats: stats),
                loading: () => _buildLoadingStats(),
                error: (error, stack) => _buildErrorStats(error),
              ),
              
              // Quick Actions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CabinetQuickActions(),
              ),
            ],
          ),
        ),
        
        // Error state content
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading cabinet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: SingleChildScrollView(
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => refreshCabinetData(ref),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getReadableErrorMessage(dynamic error) {
    final errorStr = error.toString();
    
    // Check for specific error types and provide user-friendly messages
    if (errorStr.contains('404') && errorStr.contains('Missing collection context')) {
      return 'Cabinet collection not found. Please restart the app or contact support.';
    } else if (errorStr.contains('404')) {
      return 'Collection not found. The cabinet feature may be temporarily unavailable.';
    } else if (errorStr.contains('Network') || errorStr.contains('Connection')) {
      return 'Network connection error. Please check your internet connection and try again.';
    } else if (errorStr.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorStr.length > 200) {
      // Truncate very long error messages
      return '${errorStr.substring(0, 200)}...';
    }
    
    return errorStr;
  }
  
  Widget _buildErrorStats(dynamic error) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Error loading stats',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddItemOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add to Cabinet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan Barcode'),
              subtitle: const Text('Scan a bottle to add it'),
              onTap: () {
                Navigator.pop(context);
                context.go('/scan');
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Drinks'),
              subtitle: const Text('Browse our drink database'),
              onTap: () {
                Navigator.pop(context);
                context.go('/drinks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Add to Wishlist'),
              subtitle: const Text('Mark a drink you want to buy'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to wishlist add page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wishlist feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sort),
              title: const Text('Sort & Filter'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show sort/filter options
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Organize by Location'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to location view
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export Cabinet'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement export
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cabinet Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showItemDetails(BuildContext context, CabinetItem item) {
    // TODO: Navigate to item detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item details for: ${item.drinkId}')),
    );
  }
  
  void _handleItemAction(String action, CabinetItem item) {
    // Handle quick actions from item cards
    switch (action) {
      case 'mark_opened':
        ref.read(cabinetNotifierProvider.notifier).markAsOpened(item.id);
        break;
      case 'mark_finished':
        ref.read(cabinetNotifierProvider.notifier).markAsFinished(item.id);
        break;
      case 'move_to_wishlist':
        ref.read(cabinetNotifierProvider.notifier).moveToWishlist(item.id);
        break;
      case 'remove':
        ref.read(cabinetNotifierProvider.notifier).removeItem(item.id);
        break;
    }
    
    // Refresh data after action
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshCabinetData(ref);
    });
  }
}