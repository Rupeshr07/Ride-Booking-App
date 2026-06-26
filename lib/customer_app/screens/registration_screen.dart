import 'package:flutter/material.dart';
import '../../main.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

import '../utils/text_styles.dart';
import '../utils/validation_utils.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../services/preference_service.dart';
import '../services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  
  String selectedGender = 'Male';
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userData = await PreferenceService.getUser();
        final phoneNumber = userData?['phoneNumber'] ?? '';

        if (phoneNumber.isEmpty) {
          throw 'Phone number not found. Please log in again.';
        }

        final response = await AuthService.register(
          phoneNumber: phoneNumber,
          name: '${_firstNameController.text} ${_lastNameController.text}',
          email: _emailController.text,
          gender: selectedGender,
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          // Set app mode permanently since registration is successful
          MainEntryApp.setAppMode(context, 'customer', permanent: true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Registration successful'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.p24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppConstants.p20),
                  // Logo Section
                  Center(
                    child: Column(
                      children: [
                        const Row(
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
                        const SizedBox(height: AppConstants.p24),
                      ],
                    ),
                  ),
                  
                  // Welcome Section
                  const Text(
                    'Welcome',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: AppConstants.p12),
                  const Text(
                    'Set up your profile to start managing your logistics and rides with kinetic precision.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppConstants.p32),
                  
                  // Input Fields
                  CustomTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    hintText: 'e.g. Julian',
                    validator: (value) => ValidationUtils.validateRequired(value, 'First Name'),
                  ),
                  const SizedBox(height: AppConstants.p24),
                  CustomTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    hintText: 'e.g. Vance',
                    validator: (value) => ValidationUtils.validateRequired(value, 'Last Name'),
                  ),
                  const SizedBox(height: AppConstants.p24),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hintText: 'e.g. julian.vance@example.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidationUtils.validateEmail,
                  ),
                  const SizedBox(height: AppConstants.p32),
                  
                  // Gender Selection
                  const Text(
                    'SELECT GENDER',
                    style: AppTextStyles.labelSmall,
                  ),
                  const SizedBox(height: AppConstants.p16),
                  Row(
                    children: [
                      Expanded(child: _buildGenderOption('Male', Icons.male)),
                      const SizedBox(width: AppConstants.p12),
                      Expanded(child: _buildGenderOption('Female', Icons.female)),
                      const SizedBox(width: AppConstants.p12),
                      Expanded(child: _buildGenderOption('Other', Icons.transgender)),
                    ],
                  ),
                  const SizedBox(height: AppConstants.p48),
                  
                  // Register Button
                  CustomButton(
                    text: 'Register',
                    isLoading: _isLoading,
                    onPressed: _handleRegistration,
                  ),
                  const SizedBox(height: AppConstants.p48),
                  
                  // Footer
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider(color: AppColors.divider)),
                      SizedBox(width: AppConstants.p12),
                      Icon(Icons.local_shipping_outlined, size: AppConstants.iconMedium, color: AppColors.textTertiary),
                      SizedBox(width: AppConstants.p12),
                      Expanded(child: Divider(color: AppColors.divider)),
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

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = selectedGender == gender;
    return InkWell(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.p16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.background : AppColors.surfaceAlternative,
          borderRadius: BorderRadius.circular(AppConstants.r12),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected ? AppConstants.cardShadow : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
              size: AppConstants.iconLarge,
            ),
            const SizedBox(height: AppConstants.p8),
            Text(
              gender,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
