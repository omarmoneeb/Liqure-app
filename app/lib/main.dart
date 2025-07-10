import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/debug/debug_page.dart';
import 'features/tasting/presentation/pages/drinks_page.dart';
import 'features/tasting/presentation/pages/drink_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: LiquorJournalApp()));
}

class LiquorJournalApp extends ConsumerWidget {
  const LiquorJournalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Liquor Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      routerConfig: _createRouter(ref),
    );
  }

  GoRouter _createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final authState = ref.read(authProvider);
        final isAuthenticated = authState.isAuthenticated;
        final isLoading = authState.isLoading;

        // If still loading, stay on splash
        if (isLoading && state.fullPath == '/splash') {
          return null;
        }

        // If not authenticated and trying to access protected routes
        if (!isAuthenticated && !_isPublicRoute(state.fullPath)) {
          return '/sign-in';
        }

        // If authenticated and trying to access auth routes
        if (isAuthenticated && _isAuthRoute(state.fullPath)) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: '/sign-up',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/debug',
          builder: (context, state) => const DebugPage(),
        ),
        GoRoute(
          path: '/drinks',
          builder: (context, state) => const DrinksPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final drinkId = state.pathParameters['id']!;
                return DrinkDetailPage(drinkId: drinkId);
              },
            ),
          ],
        ),
      ],
    );
  }

  bool _isPublicRoute(String? path) {
    const publicRoutes = ['/splash', '/sign-in', '/sign-up'];
    return publicRoutes.contains(path);
  }

  bool _isAuthRoute(String? path) {
    const authRoutes = ['/sign-in', '/sign-up'];
    return authRoutes.contains(path);
  }
}

// Splash page to handle initial loading
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state to redirect when ready
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!next.isLoading) {
        if (next.isAuthenticated) {
          context.go('/home');
        } else {
          context.go('/sign-in');
        }
      }
    });

    return const Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wine_bar,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Liquor Journal',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Track your spirits journey',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Temporary Home page
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              context.go('/debug');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wine_bar,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Liquor Journal!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (authState.user != null) ...[
              Text('Email: ${authState.user!.email}'),
              if (authState.user!.username != null)
                Text('Username: ${authState.user!.username}'),
            ],
            const SizedBox(height: 32),
            const Text(
              'Quick Actions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _buildActionButton(
                    context,
                    'Browse Drinks',
                    Icons.wine_bar,
                    Colors.amber,
                    () => context.go('/drinks'),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context,
                    'Add New Drink',
                    Icons.add_circle,
                    Colors.green,
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add drink feature coming soon!')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context,
                    'My Ratings',
                    Icons.star,
                    Colors.blue,
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ratings feature coming soon!')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
