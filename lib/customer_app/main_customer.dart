import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/vehicle_selection_screen.dart';
import 'screens/booking_confirmation_screen.dart';
import 'screens/driver_assigned_screen.dart';
import 'screens/pin_verification_screen.dart';
import 'screens/live_tracking_screen.dart';
import 'screens/ride_complete_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/location_selection_screen.dart';
import 'utils/colors.dart';
import 'services/preference_service.dart';

class CustomerApp extends StatelessWidget {
  const CustomerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A.R.C Ride Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: PreferenceService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data == true) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/otp': (context) => const OTPScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/location_selection': (context) => const LocationSelectionScreen(title: 'Location'),
        '/vehicle_selection': (context) => const VehicleSelectionScreen(),
        '/booking_confirmation': (context) => const BookingConfirmationScreen(),
        '/driver_assigned': (context) => const DriverAssignedScreen(),
        '/live_tracking': (context) => const LiveTrackingScreen(),
        '/ride_complete': (context) => const RideCompleteScreen(),
      },
    );
  }
}

