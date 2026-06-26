import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ride_provider.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import 'pin_verification_screen.dart';

class PickupRouteScreen extends StatelessWidget {
  const PickupRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Pickup Route'),
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
                    Icon(Icons.map, size: 80, color: Colors.blue[200]),
                    const SizedBox(height: 16),
                    const Text('Map Navigation Visualization', style: TextStyle(color: Colors.blueGrey)),
                  ],
                ),
              ),
            ),
            
            // Floating Button for "Arrived"
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
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: DriverColors.secondary,
                          child: Icon(Icons.person, color: DriverColors.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'James Carter',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text('3 min away', style: TextStyle(color: DriverColors.textSecondary)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.call, color: DriverColors.success),
                          style: IconButton.styleFrom(backgroundColor: DriverColors.success.withOpacity(0.1)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Consumer<RideProvider>(
                      builder: (context, rideProvider, _) => CustomButton(
                        text: rideProvider.status == RideStatus.arrivedAtPickup 
                            ? 'VERIFY CUSTOMER PIN' 
                            : 'I HAVE ARRIVED',
                        onPressed: () {
                          if (rideProvider.status == RideStatus.accepted) {
                            rideProvider.arriveAtPickup();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PinVerificationScreen()),
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
