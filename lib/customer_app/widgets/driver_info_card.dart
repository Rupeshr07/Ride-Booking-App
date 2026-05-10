import 'package:flutter/material.dart';
 import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/text_styles.dart';

class DriverInfoCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String rating;
  final String? profileImage;
  final VoidCallback onCall;
  final VoidCallback onChat;

  const DriverInfoCard({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.rating,
    this.profileImage,
    required this.onCall,
    required this.onChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.p20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.r24),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: profileImage != null ? NetworkImage(profileImage!) : null,
                backgroundColor: AppColors.surface,
                child: profileImage == null ? const Icon(Icons.person, color: AppColors.primary) : null,
              ),
              const SizedBox(width: AppConstants.p16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.h2),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(rating, style: AppTextStyles.labelMedium),
                        const SizedBox(width: 12),
                        const Icon(Icons.verified, color: AppColors.success, size: 16),
                        const SizedBox(width: 4),
                        Text('VERIFIED', style: AppTextStyles.labelMedium.copyWith(color: AppColors.success)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(phoneNumber, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onChat,
                    icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onCall,
                    icon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
