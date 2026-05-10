import 'package:flutter/material.dart';
 import '../utils/colors.dart';
import '../utils/constants.dart';
 import '../utils/text_styles.dart';
import '../widgets/bottom_sheet_container.dart';
import '../widgets/driver_info_card.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String pickup = args?['pickup'] ?? 'Express Cargo Terminal';
    final String drop = args?['dropoff'] ?? 'Downtown Logistics Hub';
    final String fare = args?['fare'] ?? '₹42.50';
    final String vehicleName = args?['vehicleType'] ?? 'Auto';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map Placeholder
          Container(
            color: AppColors.surface,
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              'https://media.wired.com/photos/59269abc8d4ebc5ab806b296/master/w_2560%2Cc_limit/GoogleMapsTA.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.map_outlined, size: 80, color: AppColors.textTertiary),
              ),
            ),
          ),

          // Header Stats Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.p20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.r24),
                      boxShadow: AppConstants.cardShadow,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.speed, size: 16, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text('12 KM/H', style: AppTextStyles.labelLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tracking Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomSheetContainer(
              title: 'Ride in Progress',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DriverInfoCard(
                    name: 'Julian Vance',
                    phoneNumber: '+91 98765 43210',
                    rating: '4.8 (120)',
                    profileImage: 'https://i.pravatar.cc/300?img=11',
                    onCall: () {},
                    onChat: () {},
                  ),
                  const SizedBox(height: AppConstants.p20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('DISTANCE', '2.4 KM'),
                      _buildStatItem('TIME LEFT', '8 MIN'),
                      _buildStatItem('FARE', fare),
                    ],
                  ),
                  const SizedBox(height: AppConstants.p24),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/ride_complete', arguments: {
                              'pickup': pickup,
                              'dropoff': drop,
                              'fare': fare,
                              'vehicleType': vehicleName,
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppConstants.r12),
                            ),
                            child: const Text(
                              'Emergency / SOS',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.labelLarge,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/ride_complete', arguments: {
                              'pickup': pickup,
                              'dropoff': drop,
                              'fare': fare,
                              'vehicleType': vehicleName,
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppConstants.r12),
                            ),
                            child: const Text(
                              'Complete Ride',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.labelLarge,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.labelMedium),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h3.copyWith(fontSize: 16)),
      ],
    );
  }
}
