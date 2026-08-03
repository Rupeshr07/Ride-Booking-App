import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/text_styles.dart';
import '../utils/validation_utils.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../services/auth_service.dart';
import '../../main.dart';

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
    Navigator.pushNamed(context, '/otp', arguments: _mobileController.text);

    // if (_formKey.currentState!.validate()) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //
    //   try {
    //     final response = await AuthService.sendOtp(_mobileController.text);
    //
    //     if (mounted) {
    //       setState(() {
    //         _isLoading = false;
    //       });
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(response['message'] ?? 'OTP sent successfully'),
    //           backgroundColor: Colors.green,
    //         ),
    //       );
    //       Navigator.pushNamed(context, '/otp', arguments: _mobileController.text);
    //     }
    //   } catch (e) {
    //     if (mounted) {
    //       setState(() {
    //         _isLoading = false;
    //       });
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
    //       );
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              child: Image.asset(
                'assets/images/selection_bg.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.6,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          
          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF0D2C54)),
              onPressed: () {
                MainEntryApp.setAppMode(context, null);
              },
            ),
          ),

          // White Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.53,
              margin: const EdgeInsets.symmetric(horizontal: 12),
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
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_arc.png',
                      height: 32,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.location_on, color: Color(0xFF0D2C54), size: 32),
                    ),
                    // Header

                    const SizedBox(height: 18),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your mobile number to receive \na verification code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 26),

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
                    const SizedBox(height: 24),
                    
                    // Button
                    CustomButton(
                      text: 'SEND OTP',
                      isLoading: _isLoading,
                      onPressed: _handleLogin,
                    ),
                    
                    const Spacer(),
                    
                    // Version info
                    const Center(
                      child: Text(
                        'A.R.C. VERSION 1.0.0',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
