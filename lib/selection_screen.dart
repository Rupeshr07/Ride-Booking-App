import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customer_app/main_customer.dart';
import 'driver_app/main_driver.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  Future<void> _setAppMode(BuildContext context, String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_mode', mode);

    if (context.mounted) {
      if (mode == 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerApp()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DriverApp()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade700],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           // logo image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
              ),),

            const SizedBox(height: 16),
            const Text(
              'A.R.C GO',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            _buildSelectionButton(
              context,
              'Login as Customer',
              Icons.person,
                  // () => _setAppMode(context, 'customer'),
              // here i want to show massage that this feature is not available for customer
                  () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Customer login is currently unavailable. Please try again later.'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSelectionButton(
              context,
              'Login as Driver',
              Icons.drive_eta,
                  () => _setAppMode(context, 'driver'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton(
      BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

