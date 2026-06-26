import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/colors.dart';
import '../providers/auth_provider.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final mobile = _mobileController.text.trim();
    final password = _passwordController.text.trim();

    if (mobile.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter mobile number and password')),
      );
      return;
    }

    final success = await context.read<AuthProvider>().login(mobile, password);

    if (success) {
      if (mounted) {
        // Set app mode permanently now that login is successful
        MainEntryApp.setAppMode(context, 'driver', permanent: true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver Login Success!'),
            backgroundColor: DriverColors.success,
          ),
        );
      }
    } else {
      if (mounted) {
        final error = context.read<AuthProvider>().error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Login failed'),
            backgroundColor: DriverColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DriverColors.primary),
          onPressed: () {
            // Return to selection screen by clearing the temp mode
            MainEntryApp.setAppMode(context, null);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: DriverColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'ARC Driver',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: DriverColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: DriverColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please sign in to your driver account',
                style: TextStyle(
                  fontSize: 16,
                  color: DriverColors.textSecondary,
                ),
              ),
              const SizedBox(height: 29),
              CustomTextField(
                controller: _mobileController,
                label: 'Mobile Number',
                hint: '000 000 0000',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hint: '********',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 29),
              Consumer<AuthProvider>(
                builder: (context, auth, _) => CustomButton(
                  text: 'Login',
                  isLoading: auth.isLoading,
                  onPressed: _handleLogin,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Need help? Contact Support',
                    style: TextStyle(color: DriverColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
