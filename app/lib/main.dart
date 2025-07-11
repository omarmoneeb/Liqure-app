import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/debug/debug_page.dart';
import 'features/tasting/presentation/pages/drinks_page.dart';
import 'features/tasting/presentation/pages/drink_detail_page.dart';
import 'features/onboarding/presentation/pages/age_gate_page.dart';
import 'features/onboarding/presentation/providers/age_verification_provider.dart';

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
        final isAgeVerified = ref.read(ageVerificationProvider);
        final isAuthenticated = authState.isAuthenticated;
        final isLoading = authState.isLoading;

        // If still loading, stay on splash
        if (isLoading && state.fullPath == '/splash') {
          return null;
        }

        // CRITICAL: Check age verification first (required for app store compliance)
        if (!isAgeVerified && state.fullPath != '/age-gate') {
          return '/age-gate';
        }

        // If age verified but not authenticated and trying to access protected routes
        if (isAgeVerified && !isAuthenticated && !_isPublicRoute(state.fullPath)) {
          return '/auth/signin';
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
          path: '/age-gate',
          builder: (context, state) => const AgeGatePage(),
        ),
        GoRoute(
          path: '/auth',
          routes: [
            GoRoute(
              path: 'signin',
              builder: (context, state) => const SignInPage(),
            ),
            GoRoute(
              path: 'signup',
              builder: (context, state) => const SignUpPage(),
            ),
          ],
        ),
        // Legacy routes for backwards compatibility
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
          builder: (context, state) => const DashboardPage(),
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
    const publicRoutes = ['/splash', '/age-gate', '/sign-in', '/sign-up', '/auth/signin', '/auth/signup'];
    return publicRoutes.contains(path);
  }

  bool _isAuthRoute(String? path) {
    const authRoutes = ['/sign-in', '/sign-up', '/auth/signin', '/auth/signup'];
    return authRoutes.contains(path);
  }
}

// Splash page to handle initial loading
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to both auth state and age verification to redirect when ready
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!next.isLoading) {
        final isAgeVerified = ref.read(ageVerificationProvider);
        
        if (!isAgeVerified) {
          context.go('/age-gate');
        } else if (next.isAuthenticated) {
          context.go('/home');
        } else {
          context.go('/auth/signin');
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

