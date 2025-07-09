import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/network/pocketbase_client.dart';

// Shared Preferences provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Auth Repository provider
final authRepositoryProvider = Provider<AuthRepositoryImpl?>((ref) {
  final pocketBaseClient = ref.watch(pocketBaseClientProvider);
  final sharedPrefsAsync = ref.watch(sharedPreferencesProvider);
  
  return sharedPrefsAsync.when(
    data: (sharedPrefs) => AuthRepositoryImpl(pocketBaseClient, sharedPrefs),
    loading: () => null,
    error: (error, stack) => null,
  );
});

// Use Cases providers
final signInUseCaseProvider = Provider<SignInUseCase?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository != null ? SignInUseCase(repository) : null;
});

final signUpUseCaseProvider = Provider<SignUpUseCase?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository != null ? SignUpUseCase(repository) : null;
});

final signOutUseCaseProvider = Provider<SignOutUseCase?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository != null ? SignOutUseCase(repository) : null;
});

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl? _authRepository;
  final SignInUseCase? _signInUseCase;
  final SignUpUseCase? _signUpUseCase;
  final SignOutUseCase? _signOutUseCase;

  AuthNotifier(
    this._authRepository,
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
  ) : super(AuthState()) {
    _checkAuthStatus();
  }

  // Loading constructor for when dependencies are not ready
  AuthNotifier._loading() : 
    _authRepository = null,
    _signInUseCase = null,
    _signUpUseCase = null,
    _signOutUseCase = null,
    super(AuthState(isLoading: true));

  Future<void> _checkAuthStatus() async {
    if (_authRepository == null) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final isAuth = await _authRepository!.isAuthenticated();
      if (isAuth) {
        final user = await _authRepository!.getCurrentUser();
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    if (_signInUseCase == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _signInUseCase!(email, password);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  Future<void> signUp(String email, String password, {String? username}) async {
    if (_signUpUseCase == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _signUpUseCase!(email, password, username: username);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  Future<void> signOut() async {
    if (_signOutUseCase == null) return;
    
    state = state.copyWith(isLoading: true);
    try {
      await _signOutUseCase!();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> sendPasswordReset(String email) async {
    if (_authRepository == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository!.sendPasswordReset(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final signInUseCase = ref.watch(signInUseCaseProvider);
  final signUpUseCase = ref.watch(signUpUseCaseProvider);
  final signOutUseCase = ref.watch(signOutUseCaseProvider);

  // If any dependency is null, return a loading state
  if (repository == null || signInUseCase == null || signUpUseCase == null || signOutUseCase == null) {
    return AuthNotifier._loading();
  }

  return AuthNotifier(repository, signInUseCase, signUpUseCase, signOutUseCase);
});