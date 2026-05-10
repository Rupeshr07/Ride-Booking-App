import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/internet_service.dart';
import 'home_screen.dart';
import 'internet_comection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;

  @override
  void initState() {
    super.initState();

    checkConnectivityAndNavigate();
  }

  checkConnectivityAndNavigate() async {
    bool isOnline = await ConnectivityUtils.isConnected();

    if (isOnline) {
      print("online\n\n\n\n\n\n\n");
      print("Connected to Mobile Network");
      _fetchAndNavigate();
      await _checkForUpdates(); // Check for updates

    } else {
      print("ofline\n\n\n\n\n\n\n");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LostInternetComection(),
          ));
    }
  }


  Future<void> _checkForUpdates() async {
    try {
      // Check for update availability
      _updateInfo = await InAppUpdate.checkForUpdate();

      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        if (_updateInfo?.immediateUpdateAllowed ?? false) {
          // Start an immediate update
          await InAppUpdate.performImmediateUpdate();
        } else if (_updateInfo?.flexibleUpdateAllowed ?? false) {
          // Start a flexible update
          await InAppUpdate.startFlexibleUpdate();
          setState(() {
            _flexibleUpdateAvailable = true;
          });
          await InAppUpdate.completeFlexibleUpdate();
          print("Flexible update completed");
        }
      } else {
        print("No updates available");
      }
    } catch (e) {
      print("Error checking for updates: $e");
    }
  }


  Future<void> _fetchAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        // Fetch the app config URL and navigate
        // final appConfigUrl = await ApiService.fetchAppConfigUrl();
        final appConfigUrl = "https://arcgo.in/wp-admin/login.php";
        if (appConfigUrl != null) {
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WebViewHomeScreen(ApiURl: "https://arcgo.in/wp-admin/login.php"),
              ),
            );
          });
        } else {
          print('No App Config URL found.');
        }
      } else {
        // final appConfigUrl = await ApiService.fetchAppConfigUrl();
        final appConfigUrl = "https://arcgo.in/wp-admin/login.php";
        if (appConfigUrl != null) {
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewHomeScreen(ApiURl: appConfigUrl),
                ),
              );
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // =================
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          initState();
        },
        child: Center(
            child: Image.asset(
          "assets/images/logo.png",
          height: 150,

        )),
      ),
    );
  }
}
