import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'providers/ride_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/colors.dart';

class DriverApp extends StatelessWidget {
  const DriverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RideProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'ARC Driver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: DriverColors.primary,
          scaffoldBackgroundColor: DriverColors.background,
          fontFamily: 'Inter',
          colorScheme: ColorScheme.fromSeed(
            seedColor: DriverColors.primary,
            primary: DriverColors.primary,
            secondary: DriverColors.accent,
            surface: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const DriverAppInitializer(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/history': (context) => const RideHistoryScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}

class DriverAppInitializer extends StatefulWidget {
  const DriverAppInitializer({Key? key}) : super(key: key);

  @override
  State<DriverAppInitializer> createState() => _DriverAppInitializerState();
}

class _DriverAppInitializerState extends State<DriverAppInitializer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAuth();
    });
  }

  Future<void> _initAuth() async {
    final auth = context.read<AuthProvider>();
    await auth.loadProfile();
    
    if (mounted) {
      final error = auth.error;
      if (error != null) {
        // If it's a real error (not just missing token on fresh start), show it
        if (!error.contains('No token') && !error.contains('Session expired')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: DriverColors.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading && auth.driver == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // If authenticated, show Home. Otherwise, show Login.
        return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}
