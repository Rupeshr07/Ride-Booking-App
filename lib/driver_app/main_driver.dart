import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ride_provider.dart';
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
        initialRoute: '/login',
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
