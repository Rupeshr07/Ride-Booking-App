import 'package:flutter/material.dart';
import 'package:ride_booking/customer_app/utils/colors.dart';
import '../utils/constants.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showHandle;

  const BottomSheetContainer({
    Key? key,
    required this.child,
    this.title,
    this.showHandle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.r24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.p20, vertical: AppConstants.p16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHandle)
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppConstants.p16),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppConstants.r8),
                ),
              ),
            ),
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.p16),
          ],
          child,
        ],
      ),
    );
  }
}
