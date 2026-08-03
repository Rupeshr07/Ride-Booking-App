import 'package:flutter/material.dart';
import 'main.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  void _selectMode(BuildContext context, String mode) {
    // Only set the UI mode, do not persist to SharedPreferences yet
    MainEntryApp.setAppMode(context, mode, permanent: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  this #F3F4FA background color
      backgroundColor: const Color(0xFFF3F4FA),
      body: Stack(
        children: [
          // Background Image showing the illustration
          Positioned(
            top: -15,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(14.0),
              child: Image.asset(
                'assets/images/selection_bg.png',
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.6,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          
          // White Card at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              height: MediaQuery.of(context).size.height * 0.53,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_arc.png',
                    height: 30,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.local_shipping, color: Color(0xFF0D2C54), size: 32),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose your login option to continue\nand access your dashboard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  
                  // Customer Login Button
                  _buildLoginOption(
                    context,
                    title: 'Customer Login',
                    subtitle: 'Track your shipments, book \norders and manage deliveries',
                    icon: Icons.person,
                    color: const Color(0xFF0D2C54),
                    onTap: () => _selectMode(context, 'customer'),
                  ),
                  const SizedBox(height: 16),
                  
                  // Driver Login Button
                  _buildLoginOption(
                    context,
                    title: 'Driver Login',
                    subtitle: 'Manage deliveries, update status\nand view assigned orders',
                    icon: Icons.drive_eta,
                    color: const Color(0xFF2E7D32),
                    onTap: () => _selectMode(context, 'driver'),
                  ),
                  
                  const Spacer(),
                  
                  // Footer Features
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFeatureItem(Icons.verified_user_outlined, 'Secure &\nReliable'),
                      _buildFeatureItem(Icons.timer_outlined, 'On Time\nDelivery'),
                      _buildFeatureItem(Icons.inventory_2_outlined, 'Safe &\nSecure'),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
