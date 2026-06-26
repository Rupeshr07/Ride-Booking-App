import 'dart:async';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
 import '../utils/text_styles.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  int _timerSeconds = 30;
  Timer? _timer;
  bool _canResend = false;
  bool _isLoading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _timerSeconds = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  String get _otpCode => _controllers.map((e) => e.text).join();

  Future<void> _verifyOTP() async {
    Navigator.pushReplacementNamed(context, '/home');

    // TODO: Implement the actual OTP verification logic here. The following code is commented out for now, but you can uncomment and modify it as needed.

    // final code = _otpCode;
    // if (code.length < 6) {
    //   setState(() {
    //     _errorText = "Please enter all 6 digits";
    //   });
    //   return;
    // }
    //
    // setState(() {
    //   _isLoading = true;
    //   _errorText = null;
    // });
    //
    // final String mobileNumber = ModalRoute.of(context)?.settings.arguments as String? ?? "";
    //
    // try {
    //   final response = await AuthService.verifyOtp(mobileNumber, code);
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //
    //     // Show success message from API
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(response['message'] ?? 'OTP Verified Successfully'),
    //         backgroundColor: Colors.green,
    //       ),
    //     );
    //
    //     // If user is already registered, set app mode permanently
    //     if (response['user'] != null && response['user']['name'] != null && response['user']['name'].toString().isNotEmpty) {
    //       MainEntryApp.setAppMode(context, 'customer', permanent: true);
    //       Navigator.pushReplacementNamed(context, '/home');
    //     } else {
    //       Navigator.pushReplacementNamed(context, '/registration');
    //     }
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //       _errorText = e.toString();
    //     });
    //   }
    // }
  }

  void _resendOTP() async {
    // TODO: Implement resend OTP logic here. The following code is commented out for now, but you can uncomment and modify it as needed.
    // if (_canResend) {
    //   final String mobileNumber = ModalRoute.of(context)?.settings.arguments as String? ?? "";
    //
    //   setState(() {
    //     _isLoading = true;
    //   });
    //
    //   try {
    //     await AuthService.sendOtp(mobileNumber);
    //     if (mounted) {
    //       setState(() {
    //         _isLoading = false;
    //       });
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('OTP resent successfully')),
    //       );
    //       _startTimer();
    //       // Clear fields
    //       for (var controller in _controllers) {
    //         controller.clear();
    //       }
    //       _focusNodes[0].requestFocus();
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
    final String mobileNumber = ModalRoute.of(context)?.settings.arguments as String? ?? "889200823";

    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.p24, vertical: AppConstants.p20),
              padding: const EdgeInsets.all(AppConstants.p24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.r30),
                boxShadow: AppConstants.cardShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Section
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppConstants.r12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, size: AppConstants.iconLarge, color: AppColors.primary),
                            SizedBox(width: AppConstants.p4),
                            Text(
                              'A.R.C',
                              style: AppTextStyles.logoText,
                            ),
                          ],
                        ),
                        Text(
                          'GO WITH AR-CHOICE',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.p24),
                  
                  const Text('OTP Verification', style: AppTextStyles.h4),
                  const SizedBox(height: AppConstants.p16),
                  
                  Text(
                    'We Will send you a one time password on this Mobile Number +91 $mobileNumber',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: AppConstants.p32),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: AppConstants.p24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Enter Verification Code', style: AppTextStyles.labelLarge),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _canResend ? AppColors.textSecondary : AppColors.timerGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _canResend ? 'Expired' : '00:${_timerSeconds.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: AppColors.textOnDark, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.p16),
                  
                  // OTP Input Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlternative,
                          borderRadius: BorderRadius.circular(AppConstants.r12),
                          border: Border.all(
                            color: _errorText != null ? AppColors.error : Colors.transparent,
                          ),
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            if (_otpCode.length == 6) {
                              _verifyOTP();
                            }
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorText!,
                      style: const TextStyle(color: AppColors.error, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: AppConstants.p24),
                  
                  InkWell(
                    onTap: _canResend ? _resendOTP : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, size: 16, color: _canResend ? AppColors.accent : AppColors.textSecondary),
                        const SizedBox(width: AppConstants.p8),
                        Text(
                          _canResend ? 'Resend OTP' : 'Resend OTP in ${_timerSeconds}s',
                          style: AppTextStyles.linkText.copyWith(
                            color: _canResend ? AppColors.accent : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.p32),
                  
                  CustomButton(
                    text: 'Verify OTP',
                    isLoading: _isLoading,
                    onPressed: _verifyOTP,
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
