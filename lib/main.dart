import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selection_screen.dart';
import 'customer_app/main_customer.dart';
import 'driver_app/main_driver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String? appMode = prefs.getString('app_mode');

  runApp(MainEntryApp(initialMode: appMode));
}

class MainEntryApp extends StatelessWidget {
  final String? initialMode;

  const MainEntryApp({super.key, this.initialMode});

  @override
  Widget build(BuildContext context) {
    if (initialMode == 'customer') {
      return const CustomerApp();
    } else if (initialMode == 'driver') {
      return const DriverApp();
    } else {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SelectionScreen(),
      );
    }
  }
}
