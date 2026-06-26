import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ride_provider.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import 'unloading_screen.dart';

class RideProgressScreen extends StatelessWidget {
  const RideProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Ride in Progress'),
          backgroundColor: Colors.white,
          foregroundColor: DriverColors.textPrimary,
          elevation: 0,
        ),
        body: Stack(
          children: [
            // Map Placeholder
            Container(
              color: Colors.blue[50],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.navigation, size: 80, color: Colors.blue[300]),
                    const SizedBox(height: 16),
                    const Text('Navigation to Destination', style: TextStyle(color: Colors.blueGrey)),
                  ],
                ),
              ),
            ),
            
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('12.5 km', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            Text('Remaining Distance', style: TextStyle(color: DriverColors.textSecondary)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('25 min', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: DriverColors.primary)),
                            Text('Est. Time', style: TextStyle(color: DriverColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: DriverColors.error),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Business Bay, Dubai, UAE',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Consumer<RideProvider>(
                      builder: (context, rideProvider, _) => CustomButton(
                        text: rideProvider.status == RideStatus.arrivedAtDestination 
                            ? 'START UNLOADING' 
                            : 'ARRIVED AT DESTINATION',
                        onPressed: () {
                          if (rideProvider.status == RideStatus.rideStarted) {
                            rideProvider.arriveAtDestination();
                          } else {
                            rideProvider.startUnloading();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const UnloadingScreen()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
