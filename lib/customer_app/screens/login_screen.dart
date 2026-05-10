import 'package:flutter/material.dart';
 import '../utils/colors.dart';
import '../utils/constants.dart';
  import '../utils/text_styles.dart';
import '../utils/validation_utils.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      print("Entered Mobile Number: ${_mobileController.text}");
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamed(context, '/otp', arguments: _mobileController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.p24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Logo Placeholder
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlternative,
                      borderRadius: BorderRadius.circular(AppConstants.r24),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, size: 48, color: AppColors.primary),
                        Text(
                          'A.R.C',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.p32),
                  const Text(
                    'Login with Mobile Number',
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: AppConstants.p32),
                  CustomTextField(
                    controller: _mobileController,
                    hintText: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                    validator: ValidationUtils.validateMobile,
                    prefix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('+91', style: AppTextStyles.bodyLarge),
                        const SizedBox(width: AppConstants.p8),
                        Container(
                          width: 1,
                          height: 24,
                          color: AppColors.divider,
                        ),
                        const SizedBox(width: AppConstants.p8),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.p24),
                  CustomButton(
                    text: 'Send OTP',
                    icon: Icons.arrow_forward,
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),
                  const Spacer(flex: 3),
                  const Column(
                    children: [
                      Icon(Icons.devices, size: 24, color: AppColors.textTertiary),
                      SizedBox(height: AppConstants.p4),
                      Text('Version 1.0.0', style: AppTextStyles.labelSmall),
                    ],
                  ),
                  const SizedBox(height: AppConstants.p16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
