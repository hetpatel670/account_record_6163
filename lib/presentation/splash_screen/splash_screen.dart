import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;
  String _loadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    // Logo scale animation
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Fade animation for smooth transition
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Set loading text
      setState(() {
        _loadingText = 'Loading preferences...';
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // Initialize SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        _loadingText = 'Preparing financial data...';
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // Check for existing data
      final hasExistingData = prefs.getBool('has_existing_data') ?? false;
      final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

      setState(() {
        _loadingText = 'Almost ready...';
      });

      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        _isLoading = false;
      });

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate based on user state
      if (mounted) {
        await _fadeAnimationController.forward();

        if (hasExistingData && !isFirstLaunch) {
          Navigator.pushReplacementNamed(context, '/main-dashboard');
        } else {
          // For first-time users, go to main dashboard
          // In a real app, this might be an onboarding flow
          await prefs.setBool('is_first_launch', false);
          Navigator.pushReplacementNamed(context, '/main-dashboard');
        }
      }
    } catch (error) {
      // Handle initialization errors
      if (mounted) {
        setState(() {
          _loadingText = 'Error initializing app';
          _isLoading = false;
        });

        // Show retry option after delay
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _showRetryDialog();
        }
      }
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Initialization Error',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Failed to initialize the app. Please try again.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                  _loadingText = 'Retrying...';
                });
                _initializeApp();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style based on theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppTheme.surfaceDark,
                          AppTheme.cardDark,
                          AppTheme.surfaceDark,
                        ]
                      : [
                          AppTheme.surfaceLight,
                          AppTheme.cardLight,
                          AppTheme.surfaceLight,
                        ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo section
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _logoScaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: _buildLogo(),
                            );
                          },
                        ),
                      ),
                    ),

                    // Loading section
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isLoading) ...[
                            SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                          ],
                          Text(
                            _loadingText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Bottom spacing
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App icon/logo
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: Colors.white,
              size: 10.w,
            ),
          ),
        ),

        SizedBox(height: 4.h),

        // App name
        Text(
          'Account Record',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 1.h),

        // App tagline
        Text(
          'Personal Finance Management',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                letterSpacing: 0.2,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
