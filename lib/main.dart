import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'theme/app_theme.dart';
import 'dummy_charts.dart';
import 'dart:math' as math;
import 'dart:math' show Random;
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('mr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const AgriAdvisorApp(),
      ),
    ),
  );
}

class AppState extends ChangeNotifier {
  String name = "Omkar";
  String role = "farmer"; // farmer | officer | ministry
  bool offline = false;
  bool isAuthenticated = false;
  bool isLoading = false;

  // Dummy weather/advisory values
  int tempC = 31;
  int rainProb = 12;
  int soilMoisture = 78;

  void toggleOffline() {
    offline = !offline;
    notifyListeners();
  }

  void setRole(String newRole) {
    role = newRole;
    notifyListeners();
  }

  // Authentication methods
  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 2));

    // Always succeed for demo
    isAuthenticated = true;
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();

    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 2));

    // Update user name
    this.name = name;

    // Always succeed for demo
    isAuthenticated = true;
    isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    isAuthenticated = false;
    notifyListeners();
  }
}

class AgriAdvisorApp extends StatelessWidget {
  const AgriAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tr('Prajna'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const RootScaffold(),
      },
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  late AnimationController _animationController;

  final _pages = [
    const DashboardScreen(),
    const ChatScreen(),
    MarketPriceTrackerScreen(),
    const WeatherScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final theme = Theme.of(context);

    // Page titles for the app bar
    final pageTitles = [
      tr('Prajna'),
      tr('Krishi Chatbot'),
      tr('Market'),
      tr('Weather'),
      tr('Profile'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          pageTitles[_index],
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _LangSelector(),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: Tween<double>(begin: 0.7, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: _pages[_index],
                ),
              );
            },
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) {
              if (_index != i) {
                setState(() => _index = i);
                _animationController.reset();
                _animationController.forward();
              }
            },
            elevation: 16,
            items: [
              BottomNavigationBarItem(
                icon: Icon(_index == 0
                    ? MaterialCommunityIcons.view_dashboard
                    : MaterialCommunityIcons.view_dashboard_outline),
                label: tr('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(_index == 1
                    ? MaterialCommunityIcons.chat
                    : MaterialCommunityIcons.chat_outline),
                label: tr('Ask'),
              ),
              BottomNavigationBarItem(
                icon: Icon(_index == 2
                    ? MaterialCommunityIcons.chart_line
                    : MaterialCommunityIcons.chart_line_variant),
                label: tr('Markets'),
              ),
              BottomNavigationBarItem(
                icon: Icon(_index == 3
                    ? MaterialCommunityIcons.weather_partly_cloudy
                    : MaterialCommunityIcons.weather_partly_cloudy),
                label: tr('Weather'),
              ),
              BottomNavigationBarItem(
                icon: Icon(_index == 4
                    ? MaterialCommunityIcons.account
                    : MaterialCommunityIcons.account_outline),
                label: tr('Profile'),
              ),
            ],
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }

  String _greeting(BuildContext context, String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return tr('greeting morning');
    if (hour < 18) return tr('greeting afternoon');
    return tr('greeting evening');
  }
}

class _LangSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.indigo.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.indigo.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.shade100.withAlpha((0.18 * 255).toInt()),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: DropdownButton<Locale>(
          value: context.locale,
          icon: Icon(Icons.language, color: Colors.indigo.shade700, size: 20),
          style: TextStyle(
            color: Colors.indigo.shade900,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          dropdownColor: Colors.indigo.shade50,
          onChanged: (loc) => context.setLocale(loc!),
          items: const [
            DropdownMenuItem(value: Locale('en'), child: Text('EN')),
            DropdownMenuItem(value: Locale('hi'), child: Text('हिं')),
            DropdownMenuItem(value: Locale('mr'), child: Text('मा')),
          ],
        ),
      ),
    );
  }
}

// -------------------- AUTH SCREENS --------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Start animations
    _controller.forward();

    // Navigate to login after delay
    Timer(const Duration(milliseconds: 2500), () {
      // Check if user is authenticated
      final appState = context.read<AppState>();
      if (appState.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade700,
              Colors.teal.shade500,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeInAnimation,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenSize.width * 0.4,
                        height: screenSize.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            MaterialCommunityIcons.sprout,
                            color: Colors.teal.shade700,
                            size: screenSize.width * 0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        tr('Prajna'),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr('farmer friends'),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 60),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final appState = context.read<AppState>();
      final success = await appState.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isLoading = appState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo & App Name
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          MaterialCommunityIcons.sprout,
                          color: Colors.teal.shade700,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tr('app_name'),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Welcome Text
                Text(
                  tr('welcome'),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr('Login'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                // Login Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: tr('email'),
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: tr('password'),
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              const Text('Remember Me'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(tr('Forgot Password')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  tr('Sign in'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Or continue with
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              tr('or'),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(MaterialCommunityIcons.google),
                            label: Text(tr('Login with google')),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Guest Mode
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: Text(tr('continue as guest')),
                      ),
                      const SizedBox(height: 32),
                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr('Dont have an account?'),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              tr('Sign Up'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final appState = context.read<AppState>();
      final success = await appState.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isLoading = appState.isLoading;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Welcome Text
                Text(
                  tr('register'),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr('Create an account'),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                // Register Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: tr('name'),
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: tr('email'),
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: tr('password'),
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmText,
                        decoration: InputDecoration(
                          labelText: tr('Confirm Password'),
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmText = !_obscureConfirmText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  tr('Sign Up'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Or continue with
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              tr('or'),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(MaterialCommunityIcons.google),
                            label: Text(tr('Login with google')),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Login Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr('Already have an account?'),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                tr('Login'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------- DASHBOARD --------------------

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _RoleSwitcher(),
        AdvisoryCard(
          title: tr('Advisory'),
          content: tr('advisory_example'),
          reasoningTitle: tr('advisory_reasoning_title'),
          reasoningBody: tr('reasoning_text'),
          badges: [
            _InfoBadge(icon: Icons.opacity, label: "${app.soilMoisture}%"),
            _InfoBadge(icon: Icons.umbrella, label: "${app.rainProb}%"),
            _InfoBadge(icon: Icons.thermostat, label: "${app.tempC}°C"),
          ],
        ),
        const QuickActionsRow(),
        const WeatherForecastCard(),
        const NewsCarousel(),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _RoleSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _roleChip(context, 'farmer', tr('role_farmer'), app.role == 'farmer'),
          const SizedBox(width: 8),
          _roleChip(
              context, 'officer', tr('role_officer'), app.role == 'officer'),
          const SizedBox(width: 8),
          _roleChip(
              context, 'ministry', tr('role_ministry'), app.role == 'ministry'),
          const Spacer(),
          IconButton(
            tooltip: tr('toggle_offline'),
            onPressed: () => context.read<AppState>().toggleOffline(),
            icon: const Icon(Icons.wifi_off),
          ),
        ],
      ),
    );
  }

  Widget _roleChip(
      BuildContext context, String role, String label, bool selected) {
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => context.read<AppState>().setRole(role),
      label: Text(label),
      selectedColor: Colors.green.shade200,
      backgroundColor: Colors.green.shade50,
      labelStyle: TextStyle(
        color: selected ? Colors.green.shade900 : Colors.green.shade700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.green.shade100.withOpacity(0.6)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.green.shade700),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.green.shade800,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class AdvisoryCard extends StatefulWidget {
  final String title;
  final String content;
  final String reasoningTitle;
  final String reasoningBody;
  final List<Widget> badges;
  const AdvisoryCard({
    super.key,
    required this.title,
    required this.content,
    required this.reasoningTitle,
    required this.reasoningBody,
    required this.badges,
  });

  @override
  State<AdvisoryCard> createState() => _AdvisoryCardState();
}

class _AdvisoryCardState extends State<AdvisoryCard>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(_animation),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(_animation),
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 8 : 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade500.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                      child: Icon(MaterialCommunityIcons.sprout,
                          color: Colors.white, size: isSmallScreen ? 24 : 28),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.green.shade900,
                          letterSpacing: 0.3,
                          fontSize: isSmallScreen ? 18 : null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: widget.badges,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50.withOpacity(0.6),
                    borderRadius:
                        BorderRadius.circular(isSmallScreen ? 14 : 16),
                  ),
                  child: Text(
                    widget.content,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: isSmallScreen ? 15 : 17,
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green.shade800,
                      padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 14 : 18,
                          vertical: isSmallScreen ? 8 : 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() => expanded = !expanded);
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        expanded
                            ? MaterialCommunityIcons.chevron_up
                            : MaterialCommunityIcons.information_outline,
                        key: ValueKey<bool>(expanded),
                        color: Colors.green.shade700,
                        size: isSmallScreen ? 18 : 20,
                      ),
                    ),
                    label: Text(
                      tr('why'),
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: expanded
                      ? Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: isSmallScreen ? 12 : 16),
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade50,
                                Colors.green.shade100.withOpacity(0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:
                                BorderRadius.circular(isSmallScreen ? 14 : 16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade100.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.reasoningTitle,
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green.shade900,
                                  fontSize: isSmallScreen ? 14 : null,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              Text(
                                widget.reasoningBody,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.green.shade800,
                                  height: 1.5,
                                  fontSize: isSmallScreen ? 13 : null,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 10 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                child: Icon(
                  MaterialCommunityIcons.lightning_bolt,
                  color: AppTheme.primaryColor,
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Text(
                tr('quick_actions'),
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                  letterSpacing: 0.2,
                  fontSize: isSmallScreen ? 14 : null,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          SizedBox(
            height: isSmallScreen ? 105 : 115,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 4),
              children: [
                _QuickAction(
                  icon: MaterialCommunityIcons.message_text_outline,
                  labelKey: tr('ask_question'),
                  routeBuilder: () => const AdvancedChatbotScreen(),
                  color: Colors.blueAccent,
                ),
                _QuickAction(
                  icon: MaterialCommunityIcons.currency_inr,
                  labelKey: tr('market_prices'),
                  routeBuilder: () => MarketPriceTrackerScreen(),
                  color: Colors.orangeAccent,
                ),
                _QuickAction(
                  icon: MaterialCommunityIcons.weather_partly_cloudy,
                  labelKey: tr('weather'),
                  routeBuilder: () => const WeatherScreen(),
                  color: Colors.blueGrey,
                ),
                _QuickAction(
                  icon: MaterialCommunityIcons.bank,
                  labelKey: tr('schemes_loans'),
                  routeBuilder: () => SchemesFinanceNavigatorScreen(),
                  color: Colors.teal,
                ),
                _QuickAction(
                  icon: MaterialCommunityIcons.alert_circle_outline,
                  labelKey: tr('pest_alerts'),
                  routeBuilder: () => const PestDiseaseAlertsScreen(),
                  color: Colors.redAccent,
                ),
                if (app.role == 'officer' || app.role == 'ministry')
                  _QuickAction(
                    icon: MaterialCommunityIcons.chart_bar,
                    labelKey: isSmallScreen ? tr('dash') : tr('ministry'),
                    routeBuilder: () => const OfficerMinistryDashboardScreen(),
                    color: Colors.purple,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Pest & Disease Alerts Screen (ensure defined) ---
class PestDiseaseAlertsScreen extends StatelessWidget {
  const PestDiseaseAlertsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // You can use your existing _dummyAlerts and _PestAlertCard here
    final alerts = _dummyAlerts;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade400),
            const SizedBox(width: 10),
            Text('Pest & Disease Alerts',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        backgroundColor: Colors.white.withAlpha((0.95 * 255).toInt()),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: alerts.length,
        itemBuilder: (context, i) => _PestAlertCard(alert: alerts[i]),
      ),
    );
  }
}

// --- Officer & Ministry Dashboard Screen (full definition) ---
class OfficerMinistryDashboardScreen extends StatefulWidget {
  const OfficerMinistryDashboardScreen({super.key});
  @override
  State<OfficerMinistryDashboardScreen> createState() =>
      _OfficerMinistryDashboardScreenState();
}

class _OfficerMinistryDashboardScreenState
    extends State<OfficerMinistryDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCrop = 'Wheat';
  String selectedRegion = 'Pune';
  DateTimeRange? selectedRange;
  final crops = ['Wheat', 'Rice', 'Maize', 'Soybean'];
  final regions = ['Pune', 'Nashik', 'Nagpur', 'Kolhapur'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.analytics, color: Colors.indigo.shade700),
            const SizedBox(width: 10),
            Text('Officer/Ministry Dashboard',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Map View'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Map View
          _OfficerMapView(),
          // Analytics
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ...existing code for analytics cards...
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: selectedCrop,
                        items: crops
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setState(() => selectedCrop = v!),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: selectedRegion,
                        items: regions
                            .map((r) =>
                                DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (v) => setState(() => selectedRegion = v!),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: const Text('Date Range'),
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2023, 1, 1),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedRange = picked);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Annual Rainfall ($selectedRegion)',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 120,
                            child: RainfallBarChart(region: selectedRegion),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Crop Impact by Rainfall',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 120,
                            child: CropImpactLineChart(
                              crop: selectedCrop,
                              region: selectedRegion,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Market Price Trends',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          SizedBox(height: 120, child: DummyOfficerLineChart()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Irrigation Requirement Heatmap',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          SizedBox(height: 80, child: _DummyHeatmap()),
                        ],
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
}

class _OfficerMapView extends StatelessWidget {
  final Map<String, LatLng> regionCoords = const {
    'Pune': LatLng(18.5204, 73.8567),
    'Nashik': LatLng(19.9975, 73.7898),
    'Nagpur': LatLng(21.1458, 79.0882),
    'Kolhapur': LatLng(16.7050, 74.2433),
  };

  @override
  Widget build(BuildContext context) {
    final _OfficerMinistryDashboardScreenState? parent =
        context.findAncestorStateOfType<_OfficerMinistryDashboardScreenState>();
    final selectedRegion = parent?.selectedRegion ?? 'Pune';
    final LatLng center = regionCoords[selectedRegion] ?? regionCoords['Pune']!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Builder(
                builder: (context) {
                  try {
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 9,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('region'),
                          position: center,
                          infoWindow: InfoWindow(title: selectedRegion),
                        ),
                        // Add more markers for pest/weather/market as needed
                      },
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                    );
                  } catch (e) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Text(
                          'Map could not be loaded.\nCheck API key, permissions, or platform support.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red.shade400),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Markers:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              Chip(
                  label: const Text('Pest Outbreak'),
                  backgroundColor: Colors.red.shade100,
                  avatar: const Icon(Icons.bug_report, color: Colors.red)),
              Chip(
                  label: const Text('Weather Anomaly'),
                  backgroundColor: Colors.blue.shade100,
                  avatar: const Icon(Icons.cloud, color: Colors.blue)),
              Chip(
                  label: const Text('Market Hotspot'),
                  backgroundColor: Colors.orange.shade100,
                  avatar: const Icon(Icons.local_fire_department,
                      color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Rainfall Bar Chart Widget ---
class RainfallBarChart extends StatelessWidget {
  final String region;
  const RainfallBarChart({super.key, required this.region});

  // Dummy rainfall data (mm) for 12 months
  final Map<String, List<double>> rainfallData = const {
    'Pune': [10, 20, 30, 80, 120, 180, 200, 170, 120, 60, 20, 10],
    'Nashik': [15, 25, 40, 90, 130, 190, 210, 180, 130, 70, 25, 15],
    'Nagpur': [12, 22, 35, 85, 125, 185, 205, 175, 125, 65, 22, 12],
    'Kolhapur': [18, 28, 45, 95, 140, 200, 220, 190, 140, 80, 28, 18],
  };

  @override
  Widget build(BuildContext context) {
    final data = rainfallData[region] ?? rainfallData['Pune']!;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = [
                  'J',
                  'F',
                  'M',
                  'A',
                  'M',
                  'J',
                  'J',
                  'A',
                  'S',
                  'O',
                  'N',
                  'D'
                ];
                return Text(months[value.toInt() % 12]);
              },
              reservedSize: 18,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          12,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data[i],
                color: Colors.blue.shade400,
                width: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        gridData: FlGridData(show: false),
      ),
    );
  }
}

// --- Crop Impact Line Chart Widget ---
class CropImpactLineChart extends StatelessWidget {
  final String crop;
  final String region;
  const CropImpactLineChart(
      {super.key, required this.crop, required this.region});

  // Dummy crop impact data: yield (tons/ha) vs rainfall (mm)
  final Map<String, List<double>> cropImpact = const {
    'Wheat': [2.5, 2.8, 3.0, 3.2, 3.5, 3.8, 4.0, 3.9, 3.7, 3.4, 3.0, 2.7],
    'Rice': [2.0, 2.3, 2.7, 3.0, 3.4, 3.9, 4.2, 4.1, 3.8, 3.3, 2.8, 2.3],
    'Maize': [1.8, 2.0, 2.3, 2.7, 3.0, 3.4, 3.7, 3.6, 3.3, 2.9, 2.4, 2.0],
    'Soybean': [1.5, 1.7, 2.0, 2.3, 2.7, 3.1, 3.4, 3.3, 3.0, 2.6, 2.1, 1.7],
  };

  @override
  Widget build(BuildContext context) {
    final data = cropImpact[crop] ?? cropImpact['Wheat']!;
    return LineChart(
      LineChartData(
        minY: (data.reduce((a, b) => a < b ? a : b) * 0.9),
        maxY: (data.reduce((a, b) => a > b ? a : b) * 1.1),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  if (value % 1 == 0) return Text(value.toStringAsFixed(1));
                  return const SizedBox.shrink();
                }),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = [
                  'J',
                  'F',
                  'M',
                  'A',
                  'M',
                  'J',
                  'J',
                  'A',
                  'S',
                  'O',
                  'N',
                  'D'
                ];
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(months[value.toInt() % 12],
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                );
              },
              reservedSize: 22,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: Colors.green.shade100)),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(12, (i) => FlSpot(i.toDouble(), data[i])),
            isCurved: true,
            color: Colors.green.shade600,
            barWidth: 4,
            belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                    colors: [Colors.green.shade100, Colors.green.shade50])),
            dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                        radius: 4,
                        color: Colors.green.shade700,
                        strokeWidth: 1.5,
                        strokeColor: Colors.white)),
          ),
        ],
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 0.5,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.green.shade50, strokeWidth: 1)),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => touchedSpots
                .map((spot) => LineTooltipItem(
                      '${spot.y.toStringAsFixed(2)} t/ha',
                      const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

// --- Dummy Data and Helper Widgets (top-level, single definition) ---
final List<Map<String, dynamic>> _dummyAlerts = [
  {
    'name': 'Fall Armyworm',
    'risk': 'High',
    'image': 'assets/alerts/armyworm.jpg',
    'prevention': [
      'Regular field monitoring',
      'Use pheromone traps',
    ],
    'treatment': [
      'Spray recommended biopesticide',
      'Remove and destroy infested plants',
    ],
    'gallery': [
      'assets/alerts/armyworm1.jpg',
      'assets/alerts/armyworm2.jpg',
    ],
  },
  {
    'name': 'Powdery Mildew',
    'risk': 'Medium',
    'image': 'assets/alerts/mildew.jpg',
    'prevention': [
      'Ensure good air circulation',
      'Avoid overhead irrigation',
    ],
    'treatment': [
      'Apply sulfur-based fungicide',
    ],
    'gallery': [
      'assets/alerts/mildew1.jpg',
      'assets/alerts/mildew2.jpg',
    ],
  },
];

class _PestAlertCard extends StatelessWidget {
  final Map<String, dynamic> alert;
  const _PestAlertCard({required this.alert});
  @override
  Widget build(BuildContext context) {
    final riskColor = {
      'Low': Colors.green,
      'Medium': Colors.orange,
      'High': Colors.red
    }[alert['risk']]!;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(alert['image']),
                  radius: 28,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alert['name'],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: riskColor.withAlpha((0.13 * 255).toInt()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.bug_report,
                                    color: riskColor, size: 18),
                                const SizedBox(width: 5),
                                Text(alert['risk'],
                                    style: TextStyle(
                                        color: riskColor,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Prevention',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            ...alert['prevention'].map<Widget>((step) => Row(
                  children: [
                    Icon(Icons.shield, color: Colors.green.shade700, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(step)),
                  ],
                )),
            const SizedBox(height: 8),
            Text('Treatment',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            ...alert['treatment'].map<Widget>((step) => Row(
                  children: [
                    Icon(Icons.healing, color: Colors.blue.shade700, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(step)),
                  ],
                )),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: alert['gallery'].length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(alert['gallery'][i],
                      width: 80, height: 80, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Move all top-level classes here
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello! How can I help you today?', 'isUser': false},
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _messages.add({'text': 'This is a demo response.', 'isUser': false});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF6F7FB), Color(0xFFE3E6F5)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade100, Colors.indigo.shade200],
                  ),
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.chat_bubble_rounded,
                    color: Colors.indigo.shade700),
              ),
              const SizedBox(width: 10),
              Text(tr('chat'),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.white.withAlpha((0.95 * 255).toInt()),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _PremiumChatBubble(
                      text: msg['text'], isUser: msg['isUser']);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.indigo.shade100.withAlpha((0.10 * 255).toInt()),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.shade50,
                            Colors.indigo.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.shade100
                                .withAlpha((0.10 * 255).toInt()),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: tr('type_message'),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        style: TextStyle(color: Colors.indigo.shade900),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.shade200,
                          Colors.indigo.shade400
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade100
                              .withAlpha((0.18 * 255).toInt()),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
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
}

class _PremiumChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const _PremiumChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final bg = isUser
        ? LinearGradient(
            colors: [Colors.indigo.shade400, Colors.indigo.shade200])
        : LinearGradient(colors: [Colors.indigo.shade50, Colors.white]);
    final fg = isUser ? Colors.white : Colors.indigo.shade900;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(6),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(6),
          );
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            gradient: bg,
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.shade100.withAlpha((0.13 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(text,
              style: TextStyle(
                  color: fg, fontSize: 15, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

// Add this class definition before _MarketPriceTrackerScreenState

// Premium Weather Forecast Card
class WeatherForecastCard extends StatelessWidget {
  const WeatherForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    final week = [
      {
        'day': 'Mon',
        'icon': MaterialCommunityIcons.weather_sunny,
        'temp': '32°C',
        'rain': '10%'
      },
      {
        'day': 'Tue',
        'icon': MaterialCommunityIcons.weather_partly_cloudy,
        'temp': '30°C',
        'rain': '20%'
      },
      {
        'day': 'Wed',
        'icon': MaterialCommunityIcons.weather_pouring,
        'temp': '29°C',
        'rain': '40%'
      },
      {
        'day': 'Thu',
        'icon': MaterialCommunityIcons.weather_cloudy,
        'temp': '28°C',
        'rain': '60%'
      },
      {
        'day': 'Fri',
        'icon': MaterialCommunityIcons.weather_sunny,
        'temp': '31°C',
        'rain': '15%'
      },
      {
        'day': 'Sat',
        'icon': MaterialCommunityIcons.weather_partly_cloudy,
        'temp': '30°C',
        'rain': '25%'
      },
      {
        'day': 'Sun',
        'icon': MaterialCommunityIcons.weather_rainy,
        'temp': '27°C',
        'rain': '50%'
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 8 : 10,
          horizontal: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            right: -20,
            top: -30,
            child: Container(
              width: isSmallScreen ? 100 : 120,
              height: isSmallScreen ? 100 : 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -20,
            child: Container(
              width: isSmallScreen ? 150 : 180,
              height: isSmallScreen ? 150 : 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        MaterialCommunityIcons.weather_partly_cloudy,
                        color: Colors.white,
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Text(
                        isSmallScreen
                            ? 'Weather Forecast'
                            : '7-Day Weather Forecast',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                          fontSize: isSmallScreen ? 14 : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                SizedBox(
                  height: isSmallScreen ? 115 : 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: week.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: isSmallScreen ? 8 : 14),
                    itemBuilder: (context, i) {
                      final day = week[i];
                      final isToday = i == 0;

                      return Container(
                        width: isSmallScreen ? 55 : 70,
                        decoration: BoxDecoration(
                          color: isToday
                              ? Colors.white
                              : Colors.white.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(isSmallScreen ? 14 : 16),
                          boxShadow: isToday
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 10 : 12,
                            horizontal: isSmallScreen ? 2 : 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day['day'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isToday
                                    ? Colors.blue.shade700
                                    : Colors.white,
                                fontSize: isSmallScreen ? 13 : 15,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 6 : 8),
                            Icon(
                              day['icon'] as IconData,
                              color:
                                  isToday ? Colors.blue.shade600 : Colors.white,
                              size: isSmallScreen ? 24 : 28,
                            ),
                            SizedBox(height: isSmallScreen ? 6 : 8),
                            Text(
                              day['temp'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isToday
                                    ? Colors.blue.shade800
                                    : Colors.white,
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 1 : 2),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 6 : 8,
                                  vertical: 2),
                              decoration: BoxDecoration(
                                color: isToday
                                    ? Colors.blue.shade100
                                    : Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                day['rain'] as String,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 9 : 10,
                                  fontWeight: FontWeight.w600,
                                  color: isToday
                                      ? Colors.blue.shade800
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Premium News Carousel
class NewsCarousel extends StatelessWidget {
  const NewsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    final List<Map<String, dynamic>> news = [
      {
        'title': 'Govt launches new crop insurance scheme',
        'summary':
            'Farmers to benefit from improved coverage and faster claims.',
        'icon': MaterialCommunityIcons.shield_check_outline,
        'color': Colors.green,
        'time': '2h ago',
      },
      {
        'title': 'Market prices surge for cotton',
        'summary': 'Cotton prices hit a 3-year high amid global demand.',
        'icon': MaterialCommunityIcons.trending_up,
        'color': Colors.orange,
        'time': '4h ago',
      },
      {
        'title': 'Pest alert: Armyworm in Maharashtra',
        'summary': 'Farmers advised to monitor crops and report outbreaks.',
        'icon': MaterialCommunityIcons.alert_circle_outline,
        'color': Colors.red,
        'time': '6h ago',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  MaterialCommunityIcons.newspaper_variant_outline,
                  color: Colors.amber.shade700,
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Text(
                tr('latest_news'),
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleMedium!.color,
                  letterSpacing: 0.2,
                  fontSize: isSmallScreen ? 14 : null,
                ),
              ),
              const Spacer(),
              if (isSmallScreen)
                IconButton(
                  onPressed: () {
                    // View all news
                  },
                  icon: Icon(
                    MaterialCommunityIcons.chevron_right,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              else
                TextButton(
                  onPressed: () {
                    // View all news
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    tr('view_all'),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: isSmallScreen ? 250 : 220, // Responsive height
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: isSmallScreen ? 0.95 : 0.92,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: isSmallScreen ? 1.8 : 2.0,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayInterval: const Duration(seconds: 5),
            ),
            items: news.map((item) {
              return Builder(
                builder: (context) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned(
                        right: -15,
                        bottom: -15,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withOpacity(0.07),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: (item['color'] as Color)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: item['color'] as Color,
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item['time'] as String,
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: isSmallScreen ? 11 : 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              item['title'] as String,
                              style: theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: isSmallScreen ? 15 : null,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['summary'] as String,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.textTheme.bodySmall!.color,
                                fontSize: isSmallScreen ? 13 : null,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  // Read more
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  tr('read_more'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 12 : 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class MarketPriceTrackerScreen extends StatefulWidget {
  const MarketPriceTrackerScreen({super.key});

  @override
  State<MarketPriceTrackerScreen> createState() =>
      _MarketPriceTrackerScreenState();
}

class _MarketPriceTrackerScreenState extends State<MarketPriceTrackerScreen>
    with SingleTickerProviderStateMixin {
  String trendType = '7-day';
  String selectedCrop = 'Wheat';
  String selectedLocation = 'Pune';
  bool showWhy = false;
  int selectedChartIndex = 0;

  late TabController _tabController;

  final List<String> crops = ['Wheat', 'Rice', 'Maize', 'Soybean'];
  final List<String> locations = ['Pune', 'Mumbai', 'Nagpur', 'Nashik'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Getter to return the appropriate data set based on selected trend type
  List<Map<String, dynamic>> get data =>
      trendType == '7-day' ? data7day : data30day;

  // Dummy price data for 7 days
  List<Map<String, dynamic>> get data7day => List.generate(7, (i) {
        final date = DateTime.now().subtract(Duration(days: 6 - i));
        // Create dummy prices with some realistic fluctuation
        final basePrice = 1900 + (i * 15);
        final variance =
            (i % 3 == 0) ? -5.0 : 8.0; // Some days drop, others rise

        final min = basePrice + variance - 30;
        final max = basePrice + variance + 70;
        final modal = basePrice + variance + 25;

        return {
          'date': date,
          'min': min.toDouble(),
          'max': max.toDouble(),
          'modal': modal.toDouble(),
        };
      });

  // Dummy price data for 30 days
  List<Map<String, dynamic>> get data30day => List.generate(30, (i) {
        final date = DateTime.now().subtract(Duration(days: 29 - i));
        // Create dummy prices with a realistic market trend
        final trend = math.sin(i / 5) * 50; // Create wave pattern
        final basePrice = 1900 + (i * 3.5) + trend;

        final min = basePrice - 20 - (Random().nextDouble() * 10);
        final max = basePrice + 60 + (Random().nextDouble() * 15);
        final modal = basePrice + 15 + (Random().nextDouble() * 10);

        return {
          'date': date,
          'min': min.toDouble(),
          'max': max.toDouble(),
          'modal': modal.toDouble(),
        };
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(MaterialCommunityIcons.chart_line,
                  color: Colors.orange.shade800, size: isSmallScreen ? 18 : 22),
            ),
            const SizedBox(width: 12),
            Text(
              'Market Price Tracker',
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        children: [
          // Filter Section
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade50,
                  Colors.orange.shade100.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Price Trends',
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Controls
                isSmallScreen
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Crop dropdown
                          DropdownButtonFormField<String>(
                            value: selectedCrop,
                            decoration: InputDecoration(
                              labelText: tr('crop'),
                              labelStyle:
                                  TextStyle(color: Colors.orange.shade800),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.orange.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.orange.shade400),
                              ),
                              prefixIcon: Icon(MaterialCommunityIcons.sprout,
                                  color: Colors.orange.shade600, size: 18),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            items: crops
                                .map((c) =>
                                    DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (v) => setState(() => selectedCrop = v!),
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.orange.shade800),
                          ),
                          const SizedBox(height: 10),
                          // Location dropdown
                          DropdownButtonFormField<String>(
                            value: selectedLocation,
                            decoration: InputDecoration(
                              labelText: tr('location'),
                              labelStyle:
                                  TextStyle(color: Colors.orange.shade800),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.orange.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.orange.shade400),
                              ),
                              prefixIcon: Icon(
                                  MaterialCommunityIcons.map_marker,
                                  color: Colors.orange.shade600,
                                  size: 18),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            items: locations
                                .map((l) =>
                                    DropdownMenuItem(value: l, child: Text(l)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => selectedLocation = v!),
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.orange.shade800),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          // Crop dropdown
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedCrop,
                              decoration: InputDecoration(
                                labelText: tr('crop'),
                                labelStyle:
                                    TextStyle(color: Colors.orange.shade800),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      BorderSide(color: Colors.orange.shade200),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      BorderSide(color: Colors.orange.shade400),
                                ),
                                prefixIcon: Icon(MaterialCommunityIcons.sprout,
                                    color: Colors.orange.shade600),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              items: crops
                                  .map((c) => DropdownMenuItem(
                                      value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => selectedCrop = v!),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.orange.shade800),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Location dropdown
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedLocation,
                              decoration: InputDecoration(
                                labelText: tr('location'),
                                labelStyle:
                                    TextStyle(color: Colors.orange.shade800),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      BorderSide(color: Colors.orange.shade200),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      BorderSide(color: Colors.orange.shade400),
                                ),
                                prefixIcon: Icon(
                                    MaterialCommunityIcons.map_marker,
                                    color: Colors.orange.shade600),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              items: locations
                                  .map((l) => DropdownMenuItem(
                                      value: l, child: Text(l)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => selectedLocation = v!),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.orange.shade800),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 16),
                // Time period selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeButton('7-day', '7-day'),
                    const SizedBox(width: 12),
                    _buildTimeButton('30-day', '30-day'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Chart Section
          Container(
            margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart header
                Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.orange.shade600
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.shade200.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          MaterialCommunityIcons.chart_line,
                          color: Colors.white,
                          size: isSmallScreen ? 18 : 22,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 10 : 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$selectedCrop Price Trend',
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.orange.shade800,
                            ),
                          ),
                          Text(
                            '$selectedLocation Market · $trendType',
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: Icon(
                          showWhy ? Icons.expand_less : Icons.info_outline,
                          color: Colors.orange.shade700,
                          size: isSmallScreen ? 18 : 20,
                        ),
                        label: Text(
                          tr('why'),
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                        onPressed: () => setState(() => showWhy = !showWhy),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Chart tabs
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.orange.shade800,
                    unselectedLabelColor: Colors.grey.shade600,
                    indicatorColor: Colors.orange.shade500,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Line Chart'),
                      Tab(text: 'Bar Chart'),
                    ],
                    onTap: (index) {
                      setState(() {
                        selectedChartIndex = index;
                      });
                    },
                  ),
                ),

                // Chart content
                Container(
                  height: isSmallScreen ? 220 : 300,
                  padding: EdgeInsets.only(
                      top: isSmallScreen ? 16 : 24,
                      left: isSmallScreen ? 8 : 16,
                      right: isSmallScreen ? 8 : 16,
                      bottom: isSmallScreen ? 8 : 16),
                  child: _buildChartByIndex(),
                ),

                // Analysis content
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: showWhy ? null : 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
                    vertical: showWhy ? (isSmallScreen ? 12 : 16) : 0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isSmallScreen ? 16 : 20),
                      bottomRight: Radius.circular(isSmallScreen ? 16 : 20),
                    ),
                  ),
                  child: showWhy
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Market Analysis',
                              style: theme.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.orange.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Prices for $selectedCrop in $selectedLocation are showing a ${trendType == '7-day' ? 'steady increase' : 'cyclical pattern'} due to seasonal demand changes and limited supply. Based on historical data, prices are expected to ${trendType == '7-day' ? 'continue rising for another 2-3 weeks' : 'stabilize in the coming month'}.',
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildMetricBadge(
                                    'Volatility', 'Moderate', Colors.amber),
                                const SizedBox(width: 8),
                                _buildMetricBadge(
                                    'Trend',
                                    trendType == '7-day'
                                        ? 'Upward'
                                        : 'Cyclical',
                                    Colors.green),
                                const SizedBox(width: 8),
                                _buildMetricBadge(
                                    'Confidence', '85%', Colors.blue),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Price Data Table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          MaterialCommunityIcons.table,
                          color: Colors.orange.shade700,
                          size: isSmallScreen ? 18 : 22,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 10 : 12),
                      Text(
                        'Price Data',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.titleMedium!.color,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 16,
                      vertical: isSmallScreen ? 0 : 8,
                    ),
                    child: DataTable(
                      columnSpacing: isSmallScreen ? 12 : 24,
                      dataRowMinHeight: isSmallScreen ? 45 : 56,
                      dataRowMaxHeight: isSmallScreen ? 45 : 56,
                      headingRowColor:
                          MaterialStateProperty.all(Colors.orange.shade50),
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                      columns: [
                        DataColumn(
                            label: Text('Date',
                                style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 14))),
                        DataColumn(
                            label: Text('Min ₹',
                                style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 14))),
                        DataColumn(
                            label: Text('Max ₹',
                                style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 14))),
                        DataColumn(
                            label: Text('Modal ₹',
                                style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 14))),
                      ],
                      rows: data
                          .sublist(data.length > 10 ? data.length - 10 : 0)
                          .map(
                            (row) => DataRow(
                              cells: [
                                DataCell(Text(
                                  "${row['date'].day}/${row['date'].month}",
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 12 : 13),
                                )),
                                DataCell(Text(
                                  "₹${row['min'].toStringAsFixed(0)}",
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 12 : 13),
                                )),
                                DataCell(Text(
                                  "₹${row['max'].toStringAsFixed(0)}",
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 12 : 13),
                                )),
                                DataCell(Text(
                                  "₹${row['modal'].toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.orange.shade800,
                                  ),
                                )),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String value, String label) {
    final bool isSelected = trendType == value;
    return InkWell(
      onTap: () => setState(() => trendType = value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade500 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.orange.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.orange.shade200.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.orange.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBadge(String label, String value, MaterialColor color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color.shade700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartByIndex() {
    switch (selectedChartIndex) {
      case 0:
        return _buildLineChart();
      case 1:
        return _buildBarChart();
      default:
        return _buildLineChart();
    }
  }

  Widget _buildLineChart() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: data.map((e) => e['min'] as double).reduce(math.min) - 50,
        maxY: data.map((e) => e['max'] as double).reduce(math.max) + 50,
        clipData: FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            left: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: trendType == '7-day' ? 1 : 5,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0 || value >= data.length)
                  return const Text('');
                final date = data[value.toInt()]['date'] as DateTime;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 9 : 11,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 100,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${value.toInt()}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: isSmallScreen ? 9 : 11,
                  ),
                );
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipRoundedRadius: 8,
            tooltipMargin: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                String title = '';
                Color color;

                if (spot.barIndex == 0) {
                  title = 'Max: ₹${spot.y.toInt()}';
                  color = Colors.green.shade700;
                } else if (spot.barIndex == 1) {
                  title = 'Modal: ₹${spot.y.toInt()}';
                  color = Colors.orange.shade700;
                } else {
                  title = 'Min: ₹${spot.y.toInt()}';
                  color = Colors.red.shade700;
                }

                return LineTooltipItem(
                  title,
                  TextStyle(color: color, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          // Max price line
          LineChartBarData(
            spots: List.generate(
              data.length,
              (i) => FlSpot(i.toDouble(), data[i]['max'] as double),
            ),
            isCurved: true,
            color: Colors.green.shade500,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.shade100.withOpacity(0.2),
            ),
          ),
          // Modal price line
          LineChartBarData(
            spots: List.generate(
              data.length,
              (i) => FlSpot(i.toDouble(), data[i]['modal'] as double),
            ),
            isCurved: true,
            color: Colors.orange.shade500,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.shade100.withOpacity(0.2),
            ),
          ),
          // Min price line
          LineChartBarData(
            spots: List.generate(
              data.length,
              (i) => FlSpot(i.toDouble(), data[i]['min'] as double),
            ),
            isCurved: true,
            color: Colors.red.shade400,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.shade100.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final visibleDataPoints = trendType == '7-day'
        ? data
        : data
            .where((item) =>
                data.indexOf(item) % 3 == 0 ||
                data.indexOf(item) == data.length - 1)
            .toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        maxY:
            visibleDataPoints.map((e) => e['max'] as double).reduce(math.max) +
                50,
        minY:
            visibleDataPoints.map((e) => e['min'] as double).reduce(math.min) -
                50,
        barGroups: List.generate(
          visibleDataPoints.length,
          (i) {
            final item = visibleDataPoints[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: item['modal'] as double,
                  width: isSmallScreen ? 12 : 16,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(6)),
                  rodStackItems: [
                    BarChartRodStackItem(
                        0, item['min'] as double, Colors.red.shade300),
                    BarChartRodStackItem(item['min'] as double,
                        item['modal'] as double, Colors.orange.shade400),
                    BarChartRodStackItem(item['modal'] as double,
                        item['max'] as double, Colors.green.shade400),
                  ],
                ),
              ],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= visibleDataPoints.length) return const Text('');
                final date =
                    visibleDataPoints[value.toInt()]['date'] as DateTime;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: isSmallScreen ? 9 : 11,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 200,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${value.toInt()}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: isSmallScreen ? 9 : 11,
                  ),
                );
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 200,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final item = visibleDataPoints[group.x];
              return BarTooltipItem(
                'Min: ₹${item['min'].toStringAsFixed(0)}\n'
                'Modal: ₹${item['modal'].toStringAsFixed(0)}\n'
                'Max: ₹${item['max'].toStringAsFixed(0)}',
                const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w500),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ...existing code...
// ...existing code...

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(tr('weather'))),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFe0f7fa), Color(0xFFf7faf7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.13),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.thermostat, color: Colors.red.shade400, size: 28),
                  const SizedBox(width: 14),
                  Text("${app.tempC}°C",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.red.shade400,
                        fontSize: 18,
                      )),
                  const Spacer(),
                  Icon(Icons.umbrella, color: Colors.blue.shade400, size: 24),
                  const SizedBox(width: 8),
                  Text("${app.rainProb}%",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade400,
                        fontSize: 16,
                      )),
                  const SizedBox(width: 14),
                  Icon(Icons.opacity, color: Colors.green.shade400, size: 24),
                  const SizedBox(width: 8),
                  Text("${app.soilMoisture}%",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade400,
                        fontSize: 16,
                      )),
                ],
              ),
            ),
          ),
          const WeatherForecastCard(),
        ],
      ),
    );
  }
}

class SchemesLoansScreen extends StatelessWidget {
  const SchemesLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('schemes_loans'))),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
              child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text("PM-Kisan Eligibility Checker"),
            subtitle: const Text("Check if you qualify and how to apply."),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
          Card(
              child: ListTile(
            leading: const Icon(Icons.credit_card_outlined),
            title: const Text("Kisan Credit Card (KCC)"),
            subtitle: const Text("Low-interest credit line for farmers."),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
          Card(
              child: ListTile(
            leading: const Icon(Icons.savings_outlined),
            title: const Text("DBT Subsidies"),
            subtitle: const Text("Fertilizer, machinery & irrigation support."),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
        ],
      ),
    );
  }
}

class NewsfeedScreen extends StatelessWidget {
  const NewsfeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      tr('news_headline_1'),
      tr('news_headline_2'),
      tr('news_headline_3'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(tr('news'))),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.newspaper_rounded),
            title: Text(items[i],
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text("Tap to read more..."),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTabIndex = 0;

  // Activity data
  final List<Map<String, dynamic>> activityData = [
    {'day': 'Mon', 'value': 4, 'type': 'Queries'},
    {'day': 'Tue', 'value': 7, 'type': 'Queries'},
    {'day': 'Wed', 'value': 3, 'type': 'Queries'},
    {'day': 'Thu', 'value': 5, 'type': 'Queries'},
    {'day': 'Fri', 'value': 8, 'type': 'Queries'},
    {'day': 'Sat', 'value': 6, 'type': 'Queries'},
    {'day': 'Sun', 'value': 2, 'type': 'Queries'},
  ];

  // Crop data
  final List<Map<String, dynamic>> cropInterests = [
    {'name': 'Wheat', 'percentage': 35},
    {'name': 'Rice', 'percentage': 25},
    {'name': 'Maize', 'percentage': 15},
    {'name': 'Soybean', 'percentage': 10},
    {'name': 'Cotton', 'percentage': 15},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with profile header
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.shade700,
                      Colors.teal.shade500,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: isSmallScreen ? 32 : 40,
                                backgroundColor: Colors.teal.shade200,
                                child: Text(
                                  app.name.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 28 : 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    app.name,
                                    style:
                                        theme.textTheme.headlineSmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      app.role == 'farmer'
                                          ? tr('role_farmer')
                                          : app.role == 'officer'
                                              ? tr('role_officer')
                                              : tr('role_ministry'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Edit profile function
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(context, '23', 'Queries'),
                            _buildStatItem(context, '5', 'Crops'),
                            _buildStatItem(context, '12', 'Alerts'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Settings and account section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Offline mode toggle
                        SwitchListTile(
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.wifi_off_rounded,
                                  color: Colors.teal.shade700,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Offline Mode",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          subtitle: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(
                              "Access key features without internet connection",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          value: app.offline,
                          onChanged: (_) =>
                              context.read<AppState>().toggleOffline(),
                          activeColor: Colors.teal.shade700,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        const Divider(),
                        // Location
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: Colors.teal.shade700,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            "Location",
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: const Text("Pune, Maharashtra"),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(),
                        // Language
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.translate_rounded,
                              color: Colors.teal.shade700,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            "Language",
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(context.locale.languageCode == 'en'
                              ? 'English'
                              : context.locale.languageCode == 'hi'
                                  ? 'हिंदी'
                                  : 'मराठी'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Show language selector
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Analytics section with tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, left: 4),
                        child: Text(
                          "Your Analytics",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Tab bar
                            TabBar(
                              controller: _tabController,
                              labelColor: Colors.teal.shade700,
                              unselectedLabelColor: Colors.grey.shade600,
                              indicatorColor: Colors.teal.shade700,
                              indicatorSize: TabBarIndicatorSize.label,
                              dividerColor: Colors.transparent,
                              tabs: const [
                                Tab(text: 'Activity'),
                                Tab(text: 'Crops'),
                              ],
                            ),

                            // Tab content
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: [
                                // Activity chart
                                Padding(
                                  key: const ValueKey('activity'),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Weekly Activity",
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: isSmallScreen ? 180 : 220,
                                        child: _buildActivityChart(context),
                                      ),
                                    ],
                                  ),
                                ),

                                // Crop interest chart
                                Padding(
                                  key: const ValueKey('crops'),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Crop Interests",
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: isSmallScreen ? 180 : 220,
                                        child: _buildCropChart(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ][selectedTabIndex],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Recent activity
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, left: 4),
                        child: Text(
                          "Recent Activity",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildActivityItem(
                              Icons.question_answer,
                              Colors.blue,
                              "Asked about pest control",
                              "Today, 10:24 AM",
                            ),
                            const Divider(height: 1, indent: 56),
                            _buildActivityItem(
                              Icons.bar_chart,
                              Colors.orange,
                              "Checked wheat market prices",
                              "Yesterday, 3:45 PM",
                            ),
                            const Divider(height: 1, indent: 56),
                            _buildActivityItem(
                              Icons.cloud,
                              Colors.teal,
                              "Viewed weather forecast",
                              "08/15, 9:12 AM",
                            ),
                            InkWell(
                              onTap: () {},
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  "View All Activity",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.teal.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Account actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.logout_rounded,
                              color: Colors.red.shade700,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            "Sign Out",
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade800,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  "AgriAdvisor v1.0.0",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      IconData icon, Color color, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildActivityChart(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        minY: 0,
        barGroups: activityData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data['value'] as double,
                width: isSmallScreen ? 12 : 16,
                color: Colors.teal.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 10,
                  color: Colors.grey.shade100,
                ),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= activityData.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    activityData[value.toInt()]['day'] as String,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 10 : 12,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                if (value % 2 == 0) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 10 : 12,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final data = activityData[group.x];
              return BarTooltipItem(
                '${data['value']} ${data['type']}',
                const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w500),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCropChart(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Row(
      children: [
        // Pie chart
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: isSmallScreen ? 30 : 40,
              sections: cropInterests.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;

                final List<Color> colorList = [
                  Colors.teal.shade300,
                  Colors.green.shade400,
                  Colors.blue.shade300,
                  Colors.amber.shade400,
                  Colors.orange.shade300,
                ];

                return PieChartSectionData(
                  color: colorList[index % colorList.length],
                  value: data['percentage'] as double,
                  title: '${data['percentage']}%',
                  radius: isSmallScreen ? 70 : 80,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Legend
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cropInterests.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;

              final List<Color> colorList = [
                Colors.teal.shade300,
                Colors.green.shade400,
                Colors.blue.shade300,
                Colors.amber.shade400,
                Colors.orange.shade300,
              ];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colorList[index % colorList.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data['name'] as String,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// --- Schemes & Finance Navigator ---
class SchemesFinanceNavigatorScreen extends StatefulWidget {
  const SchemesFinanceNavigatorScreen({super.key});
  @override
  State<SchemesFinanceNavigatorScreen> createState() =>
      _SchemesFinanceNavigatorScreenState();
}

class _SchemesFinanceNavigatorScreenState
    extends State<SchemesFinanceNavigatorScreen> {
  int step = 0;
  String landSize = '';
  String crop = '';
  String state = '';
  final List<String> crops = ['Wheat', 'Rice', 'Maize', 'Soybean'];
  final List<String> states = ['Maharashtra', 'Punjab', 'UP', 'MP'];
  final List<Map<String, String>> schemes = [
    {
      'title': 'PM-Kisan',
      'eligibility': 'Small/marginal farmers, up to 2 ha land',
      'benefits': '₹6000/year direct benefit',
      'apply': 'https://pmkisan.gov.in/',
    },
    {
      'title': 'Kisan Credit Card (KCC)',
      'eligibility': 'All farmers, valid land records',
      'benefits': 'Low-interest credit line',
      'apply': 'https://pmkisan.gov.in/',
    },
    {
      'title': 'DBT Subsidies',
      'eligibility': 'Registered farmers',
      'benefits': 'Fertilizer, machinery, irrigation support',
      'apply': 'https://dbtbharat.gov.in/',
    },
  ];
  final List<Map<String, String>> loans = [
    {
      'title': 'Agri Gold Loan',
      'branch': 'SBI, Pune',
      'contact': '+91-9876543210',
    },
    {
      'title': 'Crop Loan',
      'branch': 'BOI, Nashik',
      'contact': '+91-9123456780',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.account_balance, color: Colors.indigo.shade700),
              const SizedBox(width: 10),
              Text('Schemes & Finance',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          backgroundColor: Colors.white.withOpacity(0.95),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Schemes'),
              Tab(text: 'Loans'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Schemes wizard
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stepper(
                    currentStep: step,
                    onStepContinue: () {
                      if (step == 0 && landSize.isEmpty) return;
                      if (step == 1 && crop.isEmpty) return;
                      if (step == 2 && state.isEmpty) return;
                      if (step < 2) setState(() => step++);
                    },
                    onStepCancel: () {
                      if (step > 0) setState(() => step--);
                    },
                    steps: [
                      Step(
                        title: const Text('Land Size'),
                        content: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Land size (hectares)'),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => setState(() => landSize = v),
                        ),
                        isActive: step == 0,
                      ),
                      Step(
                        title: const Text('Crop'),
                        content: DropdownButtonFormField<String>(
                          value: crop.isEmpty ? null : crop,
                          items: crops
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => crop = v!),
                          decoration: const InputDecoration(labelText: 'Crop'),
                        ),
                        isActive: step == 1,
                      ),
                      Step(
                        title: const Text('State'),
                        content: DropdownButtonFormField<String>(
                          value: state.isEmpty ? null : state,
                          items: states
                              .map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) => setState(() => state = v!),
                          decoration: const InputDecoration(labelText: 'State'),
                        ),
                        isActive: step == 2,
                      ),
                    ],
                  ),
                  if (step == 2)
                    Expanded(
                      child: ListView(
                        children: schemes
                            .map((s) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 2,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(s['title']!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors
                                                        .indigo.shade900)),
                                        const SizedBox(height: 6),
                                        Text('Eligibility: ${s['eligibility']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        Text('Benefits: ${s['benefits']}'),
                                        const SizedBox(height: 10),
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.open_in_new),
                                          label: const Text('Apply'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.indigo.shade400,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                          onPressed: () {
                                            // You can open the link using url_launcher if needed
                                            // launchUrl(Uri.parse(s['apply']!));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            // Loans tab
            Padding(
              padding: const EdgeInsets.all(18),
              child: ListView(
                children: loans
                    .map((l) => Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            leading: const Icon(
                                Icons.account_balance_wallet_outlined),
                            title: Text(l['title']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            subtitle: Text(
                                '${l['branch']}\nContact: ${l['contact']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.phone),
                              onPressed: () {
                                // launch('tel:${l['contact']}');
                              },
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy line chart for Officer/Ministry analytics
// Removed unused _DummyOfficerLineChart and _OfficerLineChartPainter classes

// Dummy heatmap for irrigation requirement
class _DummyHeatmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          8,
          (i) => Expanded(
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Color.lerp(
                        Colors.green.shade100, Colors.red.shade400, i / 7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )),
    );
  }
}

// --- Conversational AI Chatbot ---
class AdvancedChatbotScreen extends StatefulWidget {
  const AdvancedChatbotScreen({Key? key}) : super(key: key);
  @override
  State<AdvancedChatbotScreen> createState() => _AdvancedChatbotScreenState();
}

class _AdvancedChatbotScreenState extends State<AdvancedChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! How can I assist you today?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
      'type': 'text',
    },
  ];
  final List<String> _smartReplies = ['Why?', 'More details', 'Translate'];

  void _sendMessage({String? text, String type = 'text'}) {
    final messageText = text ?? _controller.text.trim();
    if (messageText.isEmpty) return;
    setState(() {
      _messages.add({
        'text': messageText,
        'isUser': true,
        'timestamp': DateTime.now(),
        'type': type,
      });
      _messages.add({
        'text': 'This is a demo response.',
        'isUser': false,
        'timestamp': DateTime.now(),
        'type': 'text',
      });
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.indigo.shade700),
            const SizedBox(width: 10),
            Text('AI Chatbot',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatMessageBubble(
                  text: msg['text'],
                  isUser: msg['isUser'],
                  timestamp: msg['timestamp'],
                  type: msg['type'],
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: _smartReplies
                  .map((reply) => ActionChip(
                        label: Text(reply),
                        onPressed: () =>
                            _sendMessage(text: reply, type: 'smart'),
                        backgroundColor: Colors.indigo.shade50,
                        labelStyle: TextStyle(
                            color: Colors.indigo.shade700,
                            fontWeight: FontWeight.w600),
                      ))
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.95 * 255).toInt()),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.shade100.withAlpha((0.10 * 255).toInt()),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic, color: Colors.indigo.shade400),
                  onPressed: () {
                    // TODO: Integrate voice input
                  },
                  tooltip: tr('voice_input'),
                ),
                IconButton(
                  icon: Icon(Icons.image, color: Colors.indigo.shade400),
                  onPressed: () {
                    // TODO: Integrate image input
                  },
                  tooltip: tr('image_input'),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade50, Colors.indigo.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade100
                              .withAlpha((0.10 * 255).toInt()),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: tr('type_message'),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      style: TextStyle(color: Colors.indigo.shade900),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade200, Colors.indigo.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.shade100
                            .withAlpha((0.18 * 255).toInt()),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String type;
  const _ChatMessageBubble(
      {required this.text,
      required this.isUser,
      required this.timestamp,
      required this.type});
  @override
  Widget build(BuildContext context) {
    final bg = isUser
        ? LinearGradient(colors: [Colors.green.shade400, Colors.green.shade200])
        : LinearGradient(colors: [Colors.green.shade50, Colors.white]);
    final fg = isUser ? Colors.white : Colors.green.shade900;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(6),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(6),
          );
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            gradient: bg,
            borderRadius: radius,
          ),
          child: Column(
            crossAxisAlignment: align,
            children: [
              Text(text,
                  style: TextStyle(
                      color: fg, fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(timestamp),
                style: TextStyle(
                    fontSize: 11,
                    color: isUser ? Colors.white70 : Colors.indigo.shade400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    if (now.difference(dt).inMinutes < 1) return 'Just now';
    if (now.difference(dt).inMinutes < 60)
      return '${now.difference(dt).inMinutes} min ago';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// --- Quick Action Button Widget (top-level, single definition) ---
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final Widget Function() routeBuilder;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.labelKey,
    required this.routeBuilder,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width to make responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust sizes based on screen width
    final itemWidth = screenWidth < 360 ? 90.0 : 110.0;
    final iconSize = screenWidth < 360 ? 22.0 : 26.0;
    final fontSize = screenWidth < 360 ? 11.0 : 12.0;

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => routeBuilder())),
      child: Container(
        width: itemWidth,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenWidth < 360 ? 40 : 50,
              width: screenWidth < 360 ? 40 : 50,
              margin: EdgeInsets.only(
                  top: screenWidth < 360 ? 8 : 12,
                  bottom: screenWidth < 360 ? 4 : 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize, color: color),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth < 360 ? 4 : 8,
                    vertical: screenWidth < 360 ? 4 : 8),
                child: Text(
                  labelKey,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
