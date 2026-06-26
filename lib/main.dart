import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selection_screen.dart';
import 'customer_app/main_customer.dart';
import 'driver_app/main_driver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainEntryApp());
}

class MainEntryApp extends StatefulWidget {
  const MainEntryApp({super.key});

  static void setAppMode(BuildContext context, String? mode, {bool permanent = false}) {
    context.findAncestorStateOfType<_MainEntryAppState>()?.updateMode(mode, permanent);
  }

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MainEntryAppState>()?.restart();
  }

  @override
  State<MainEntryApp> createState() => _MainEntryAppState();
}

class _MainEntryAppState extends State<MainEntryApp> {
  Key key = UniqueKey();
  String? _appMode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppMode();
  }

  Future<void> _loadAppMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _appMode = prefs.getString('app_mode');
      _isLoading = false;
    });
  }

  void updateMode(String? mode, bool permanent) async {
    if (permanent && mode != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_mode', mode);
    } else if (mode == null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('app_mode');
    }
    
    setState(() {
      _appMode = mode;
      key = UniqueKey();
    });
  }

  void restart() {
    setState(() {
      _isLoading = true;
      key = UniqueKey();
    });
    _loadAppMode();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return KeyedSubtree(
      key: key,
      child: _buildApp(),
    );
  }

  Widget _buildApp() {
    if (_appMode == 'customer') {
      return const CustomerApp();
    } else if (_appMode == 'driver') {
      return const DriverApp();
    } else {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SelectionScreen(),
      );
    }
  }
}
