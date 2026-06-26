import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../providers/auth_provider.dart';
import '../../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driver = context.watch<AuthProvider>().driver;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Driver Profile'),
        backgroundColor: Colors.white,
        foregroundColor: DriverColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/driver_placeholder.png'),
              backgroundColor: DriverColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              driver?.name ?? 'Loading...',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'ID: ${driver?.id ?? "N/A"} | Verified Driver',
              style: const TextStyle(color: DriverColors.success, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            _buildInfoSection(driver),
            const SizedBox(height: 24),
            _buildActionItem(Icons.edit, 'Edit Profile', () {}),
            _buildActionItem(Icons.local_shipping, 'Vehicle Information', () {}),
            _buildActionItem(Icons.help_outline, 'Help & Support', () {}),
            _buildActionItem(Icons.policy_outlined, 'Privacy Policy', () {}),
            _buildActionItem(Icons.logout, 'Logout', () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout', style: TextStyle(color: DriverColors.error)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  MainEntryApp.restartApp(context);
                }
              }
            }, isDestructive: true),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(driver) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DriverColors.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.phone, 'Phone Number', driver?.phoneNumber ?? 'N/A'),
          const Divider(height: 24),
          _buildInfoRow(Icons.local_shipping, 'Vehicle Number', driver?.vehicleNo ?? 'N/A'),
          const Divider(height: 24),
          _buildInfoRow(Icons.online_prediction, 'Status', (driver?.isOnline ?? false) ? 'Online' : 'Offline'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: DriverColors.primary),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: DriverColors.textSecondary)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDestructive ? DriverColors.error : DriverColors.textPrimary),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? DriverColors.error : DriverColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}

