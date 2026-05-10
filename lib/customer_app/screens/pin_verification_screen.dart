// import 'package:flutter/material.dart';
// import '../utils/colors.dart';
// import '../utils/constants.dart';
// import '../utils/text_styles.dart';
// import '../widgets/bottom_sheet_container.dart';
// import '../widgets/custom_button.dart';
//
// class PinVerificationScreen extends StatelessWidget {
//   const PinVerificationScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // Map Placeholder
//           Container(
//             color: AppColors.surface,
//             width: double.infinity,
//             height: double.infinity,
//             child: Image.network(
//               'https://media.wired.com/photos/59269abc8d4ebc5ab806b296/master/w_2560%2Cc_limit/GoogleMapsTA.jpg',
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => const Center(
//                 child: Icon(Icons.map_outlined, size: 80, color: AppColors.textTertiary),
//               ),
//             ),
//           ),
//
//           // Back Button
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(AppConstants.p20),
//               child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 radius: 24,
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ),
//           ),
//
//           // PIN Bottom Sheet
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: BottomSheetContainer(
//               title: 'Ride Verification',
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Share this 4-digit PIN with your driver to start the ride.',
//                     textAlign: TextAlign.center,
//                     style: AppTextStyles.bodyMedium,
//                   ),
//                   const SizedBox(height: AppConstants.p24),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildPinDigit('1'),
//                       _buildPinDigit('2'),
//                       _buildPinDigit('3'),
//                       _buildPinDigit('4'),
//                     ],
//                   ),
//                   const SizedBox(height: AppConstants.p32),
//                   CustomButton(
//                     text: 'Done',
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/live_tracking');
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPinDigit(String digit) {
//     return Container(
//       width: 60,
//       height: 70,
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(AppConstants.r12),
//         border: Border.all(color: AppColors.divider),
//       ),
//       child: Center(
//         child: Text(
//           digit,
//           style: AppTextStyles.h1.copyWith(fontSize: 32, color: AppColors.primary),
//         ),
//       ),
//     );
//   }
// }
