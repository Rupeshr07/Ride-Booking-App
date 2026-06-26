import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ride_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/colors.dart';
import '../widgets/ride_request_card.dart';
import 'pickup_route_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Show login success message when home screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver Login Success!'),
            backgroundColor: DriverColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final driver = context.watch<AuthProvider>().driver;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/driver_placeholder.png'),
              backgroundColor: DriverColors.secondary,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver?.name ?? 'Driver',
                  style: const TextStyle(
                    color: DriverColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ID: ${driver?.id ?? "N/A"}',
                  style: const TextStyle(
                    color: DriverColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Consumer<RideProvider>(
            builder: (context, rideProvider, _) => Switch(
              value: rideProvider.isOnline,
              onChanged: (value) => rideProvider.toggleOnline(),
              activeColor: DriverColors.success,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Consumer<RideProvider>(
              builder: (context, rideProvider, _) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: rideProvider.isOnline
                      ? DriverColors.success.withOpacity(0.1)
                      : DriverColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      rideProvider.isOnline ? Icons.check_circle : Icons.offline_bolt,
                      color: rideProvider.isOnline ? DriverColors.success : DriverColors.error,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      rideProvider.isOnline ? 'You are Online' : 'You are Offline',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: rideProvider.isOnline ? DriverColors.success : DriverColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Consumer<RideProvider>(
                builder: (context, rideProvider, _) {
                  if (!rideProvider.isOnline) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Go online to start receiving ride requests',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  if (rideProvider.status == RideStatus.idle) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Searching for nearby requests...'),
                        ],
                      ),
                    );
                  }

                  if (rideProvider.status == RideStatus.requestReceived) {
                    return RideRequestCard(
                      onAccept: () {
                        rideProvider.acceptRide();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PickupRouteScreen()),
                        );
                      },
                      onReject: () => rideProvider.rejectRide(),
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Active Ride in Progress'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate back to current step screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PickupRouteScreen()),
                            );
                          },
                          child: const Text('Resume Trip'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: DriverColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/history');
          if (index == 2) Navigator.pushNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
