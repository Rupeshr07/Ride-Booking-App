import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
 import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/text_styles.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleCard({
    Key? key,
    required this.vehicle,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.p12),
        padding: const EdgeInsets.all(AppConstants.p16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.r12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: AppConstants.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.r8),
              ),
              child: const Center(
                child: Icon(Icons.electric_rickshaw, color: AppColors.primary, size: 30),
              ),
            ),
            const SizedBox(width: AppConstants.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.type, style: AppTextStyles.h3),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(vehicle.description, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${vehicle.baseFare.toStringAsFixed(2)}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                ),
                if (vehicle.estimatedTime != null)
                  Text(
                    vehicle.estimatedTime!,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
