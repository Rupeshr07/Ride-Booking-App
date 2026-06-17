import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ride_provider.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import 'ride_progress_screen.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Loading Process'),
        backgroundColor: Colors.white,
        foregroundColor: DriverColors.textPrimary,
        elevation: 0,
      ),
      body: Consumer<RideProvider>(
        builder: (context, rideProvider, _) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildStatusIcon(rideProvider.status),
                const SizedBox(height: 32),
                Text(
                  _getStatusTitle(rideProvider.status),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  _getStatusDescription(rideProvider.status),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: DriverColors.textSecondary),
                ),
                const SizedBox(height: 48),
                if (rideProvider.status == RideStatus.loadingInProgress)
                  const LinearProgressIndicator(
                    backgroundColor: DriverColors.secondary,
                    color: DriverColors.primary,
                    minHeight: 10,
                  ),
                const Spacer(),
                if (rideProvider.status == RideStatus.pinVerified)
                  CustomButton(
                    text: 'START LOADING',
                    onPressed: () => rideProvider.startLoading(),
                  )
                else if (rideProvider.status == RideStatus.loadingInProgress)
                  CustomButton(
                    text: 'STOP LOADING / COMPLETED',
                    onPressed: () => rideProvider.completeLoading(),
                  )
                else if (rideProvider.status == RideStatus.loadingCompleted)
                  CustomButton(
                    text: 'START RIDE',
                    onPressed: () {
                      rideProvider.startRide();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RideProgressScreen()),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIcon(RideStatus status) {
    IconData icon;
    Color color;
    if (status == RideStatus.loadingInProgress) {
      icon = Icons.hourglass_top;
      color = DriverColors.accent;
    } else if (status == RideStatus.loadingCompleted) {
      icon = Icons.check_circle;
      color = DriverColors.success;
    } else {
      icon = Icons.inventory_2;
      color = DriverColors.primary;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 60, color: color),
    );
  }

  String _getStatusTitle(RideStatus status) {
    switch (status) {
      case RideStatus.pinVerified: return 'Ready to Load';
      case RideStatus.loadingInProgress: return 'Loading in Progress...';
      case RideStatus.loadingCompleted: return 'Loading Completed';
      default: return 'Loading';
    }
  }

  String _getStatusDescription(RideStatus status) {
    switch (status) {
      case RideStatus.pinVerified: return 'Confirm when you start loading the goods into the vehicle.';
      case RideStatus.loadingInProgress: return 'Please wait while the goods are being loaded. Keep the app open.';
      case RideStatus.loadingCompleted: return 'All goods have been loaded successfully. You can now start the ride.';
      default: return '';
    }
  }
}
