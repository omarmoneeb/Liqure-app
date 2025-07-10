import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/dashboard_providers.dart';
import '../../domain/entities/user_statistics.dart';
import '../widgets/statistic_card.dart';
import '../widgets/rating_overview_card.dart';
import '../widgets/collection_stats_card.dart';
import '../widgets/activity_card.dart';
import '../widgets/quick_actions_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userStatsAsync = ref.watch(userStatisticsProvider);
    final recentActivityAsync = ref.watch(userRecentActivityProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.amber,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => context.go('/debug'),
            tooltip: 'Debug',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh all dashboard data
          ref.invalidate(userStatisticsProvider);
          ref.invalidate(userRecentActivityProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              _buildWelcomeHeader(authState.user?.username ?? authState.user?.email ?? 'User'),
              
              const SizedBox(height: 24),
              
              // Quick Stats Overview
              userStatsAsync.when(
                data: (stats) => _buildQuickStatsGrid(context, stats),
                loading: () => _buildLoadingStatsGrid(),
                error: (error, stack) => _buildErrorWidget('Failed to load statistics'),
              ),
              
              const SizedBox(height: 16),
              
              // Rating Overview Card
              userStatsAsync.when(
                data: (stats) => RatingOverviewCard(statistics: stats),
                loading: () => const RatingOverviewCard(
                  statistics: UserStatistics(),
                  isLoading: true,
                ),
                error: (error, stack) => _buildErrorWidget('Failed to load rating overview'),
              ),
              
              const SizedBox(height: 16),
              
              // Collection Stats and Activity Column
              Column(
                children: [
                  // Collection Stats
                  userStatsAsync.when(
                    data: (stats) => CollectionStatsCard(statistics: stats),
                    loading: () => const CollectionStatsCard(
                      statistics: UserStatistics(),
                      isLoading: true,
                    ),
                    error: (error, stack) => _buildErrorWidget('Failed to load collection stats'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Activity Card
                  Consumer(
                    builder: (context, ref, child) {
                      final stats = userStatsAsync.value ?? const UserStatistics();
                      final activity = recentActivityAsync.value ?? [];
                      final isLoading = userStatsAsync.isLoading || recentActivityAsync.isLoading;
                      
                      return ActivityCard(
                        statistics: stats,
                        recentActivity: activity,
                        isLoading: isLoading,
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Quick Actions
              const QuickActionsSection(),
              
              const SizedBox(height: 16),
              
              // Achievements Section (if user has achievements)
              userStatsAsync.when(
                data: (stats) => stats.achievements.isNotEmpty 
                    ? _buildAchievementsSection(stats.achievements)
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              ),
              
              // Bottom padding for scroll
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String username) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;
    
    if (hour < 12) {
      greeting = 'Good Morning';
      greetingIcon = Icons.wb_sunny;
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      greetingIcon = Icons.wb_sunny_outlined;
    } else {
      greeting = 'Good Evening';
      greetingIcon = Icons.nightlight_round;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade400,
            Colors.orange.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      greetingIcon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      greeting,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ready to explore more spirits?',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.wine_bar,
            color: Colors.white70,
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsGrid(BuildContext context, UserStatistics stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        StatisticCard(
          title: 'Total Ratings',
          value: stats.totalRatings.toString(),
          subtitle: stats.hasRatings ? 'Keep it up!' : 'Start rating!',
          icon: Icons.star,
          color: Colors.amber,
          onTap: () => context.go('/drinks'),
        ),
        StatisticCard(
          title: 'Average Rating',
          value: stats.hasRatings ? stats.averageRating.toStringAsFixed(1) : '0.0',
          subtitle: stats.hasRatings ? stats.ratingQualityDescription : 'No ratings',
          icon: Icons.trending_up,
          color: Colors.blue,
          onTap: () => context.go('/drinks'),
        ),
        StatisticCard(
          title: 'Countries',
          value: stats.uniqueCountries.toString(),
          subtitle: stats.uniqueCountries > 5 ? 'World traveler!' : 'Explore more!',
          icon: Icons.public,
          color: Colors.green,
          onTap: () => context.go('/drinks'),
        ),
        StatisticCard(
          title: 'This Month',
          value: stats.ratingsThisMonth.toString(),
          subtitle: stats.activityLevelDescription,
          icon: Icons.timeline,
          color: Colors.purple,
          onTap: () => context.go('/drinks'),
        ),
      ],
    );
  }

  Widget _buildLoadingStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        const StatisticCard(
          title: 'Total Ratings',
          value: '...',
          icon: Icons.star,
          color: Colors.amber,
          isLoading: true,
        ),
        const StatisticCard(
          title: 'Average Rating',
          value: '...',
          icon: Icons.trending_up,
          color: Colors.blue,
          isLoading: true,
        ),
        const StatisticCard(
          title: 'Countries Explored',
          value: '...',
          icon: Icons.public,
          color: Colors.green,
          isLoading: true,
        ),
        const StatisticCard(
          title: 'Activity Level',
          value: '...',
          icon: Icons.timeline,
          color: Colors.purple,
          isLoading: true,
        ),
      ],
    );
  }

  Widget _buildAchievementsSection(List<String> achievements) {
    return Card(
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
                Icon(
                  Icons.emoji_events,
                  color: Colors.orange,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: achievements.map((achievement) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      achievement,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Card(
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}