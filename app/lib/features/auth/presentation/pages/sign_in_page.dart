import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../../../../core/error/auth_error_handler.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _showOfflineOptions = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    // Check if demo mode is already enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDemoMode();
    });
  }
  
  void _checkDemoMode() async {
    final isDemoMode = await ref.read(authProvider.notifier).isDemoModeEnabled();
    if (isDemoMode) {
      setState(() {
        _showOfflineOptions = true;
      });
    }
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email first')),
      );
      return;
    }
    
    ref.read(authProvider.notifier).sendPasswordReset(_emailController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset email sent!')),
    );
  }
  
  void _handleDemoMode() {
    ref.read(authProvider.notifier).enableDemoMode();
  }
  
  void _showConnectionErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.orange),
            SizedBox(width: 8),
            Text('Connection Issue'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unable to connect to the authentication server.'),
            SizedBox(height: 8),
            Text('This might be because:'),
            SizedBox(height: 4),
            Text('• You are not connected to the internet'),
            Text('• The server is temporarily unavailable'),
            Text('• You are on a mobile device and the server is running on localhost'),
            SizedBox(height: 12),
            Text('You can try:'),
            SizedBox(height: 4),
            Text('• Check your internet connection'),
            Text('• Try again later'),
            Text('• Use demo mode to explore the app'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDemoMode();
            },
            child: const Text('Try Demo Mode'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Listen for auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        // Check if it's a connection error using the error handler
        if (AuthErrorHandler.isConnectionError(next.error!)) {
          _showConnectionErrorDialog();
          setState(() {
            _showOfflineOptions = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
        ref.read(authProvider.notifier).clearError();
      }
      
      if (next.isAuthenticated) {
        // Navigate to home page
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48, // Account for padding
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top spacing - flexible to adapt to keyboard
                          const Flexible(
                            flex: 1,
                            child: SizedBox(height: 40),
                          ),
                          
                          // Logo/Title
                          const Icon(
                            Icons.wine_bar,
                            size: 80,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Liquor Journal',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Track your spirits journey',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                          
                          // Email Field
                          AuthTextField(
                            controller: _emailController,
                            label: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Password Field
                          AuthTextField(
                            controller: _passwordController,
                            label: 'Password',
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: _handleSignIn,
                            prefixIcon: Icons.lock_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          
                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _handleForgotPassword,
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Sign In Button
                          AuthButton(
                            text: 'Sign In',
                            onPressed: _handleSignIn,
                            isLoading: authState.isLoading,
                          ),
                          const SizedBox(height: 16),
                          
                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              TextButton(
                                onPressed: () {
                                  context.go('/sign-up');
                                },
                                child: const Text('Sign Up'),
                              ),
                            ],
                          ),
                          
                          // Offline Options (shown after connection error)
                          if (_showOfflineOptions) ...
                          [
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),
                            
                            // Connection Status
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.wifi_off, color: Colors.orange),
                                      SizedBox(width: 8),
                                      Text(
                                        'Server Connection Unavailable',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'You can still explore the app using demo mode or create an offline account.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Demo Mode Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _handleDemoMode,
                                      icon: const Icon(Icons.explore),
                                      label: const Text('Try Demo Mode'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Offline Sign In Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        // Show info about offline sign in
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Offline Sign In'),
                                            content: const Text(
                                              'You can sign in with an account you previously created offline, or create a new offline account. These accounts will sync when the server becomes available.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.offline_bolt),
                                      label: const Text('Offline Sign In Info'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          
                          // Bottom spacing - flexible to adapt to keyboard
                          const Flexible(
                            flex: 1,
                            child: SizedBox(height: 40),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}