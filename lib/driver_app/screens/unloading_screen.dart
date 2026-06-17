import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ride_provider.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import 'ride_completion_screen.dart';

class UnloadingScreen extends StatelessWidget {
  const UnloadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Unloading Process'),
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
                if (rideProvider.status == RideStatus.unloadingInProgress)
                  const LinearProgressIndicator(
                    backgroundColor: DriverColors.secondary,
                    color: DriverColors.primary,
                    minHeight: 10,
                  ),
                const Spacer(),
                if (rideProvider.status == RideStatus.unloadingInProgress)
                  CustomButton(
                    text: 'STOP UNLOADING / COMPLETED',
                    onPressed: () => rideProvider.completeUnloading(),
                  )
                else if (rideProvider.status == RideStatus.unloadingCompleted)
                  CustomButton(
                    text: 'COMPLETE RIDE',
                    onPressed: () {
                      rideProvider.completeRide();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RideCompletionScreen()),
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
    if (status == RideStatus.unloadingInProgress) {
      icon = Icons.hourglass_bottom;
      color = DriverColors.accent;
    } else if (status == RideStatus.unloadingCompleted) {
      icon = Icons.check_circle;
      color = DriverColors.success;
    } else {
      icon = Icons.local_shipping;
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
      case RideStatus.unloadingInProgress: return 'Unloading in Progress...';
      case RideStatus.unloadingCompleted: return 'Unloading Completed';
      default: return 'Unloading';
    }
  }

  String _getStatusDescription(RideStatus status) {
    switch (status) {
      case RideStatus.unloadingInProgress: return 'Please wait while the goods are being unloaded at the destination.';
      case RideStatus.unloadingCompleted: return 'All goods have been unloaded. You can now finalize the ride.';
      default: return '';
    }
  }
}
