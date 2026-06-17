import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import 'payment_screen.dart';

class RideCompletionScreen extends StatelessWidget {
  const RideCompletionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Trip Summary'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: DriverColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: DriverColors.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Fare',
                    style: TextStyle(fontSize: 16, color: DriverColors.textSecondary),
                  ),
                  const Text(
                    '\$125.00',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: DriverColors.primary),
                  ),
                  const Divider(height: 32),
                  _buildSummaryRow(Icons.route, 'Total Distance', '15.2 km'),
                  _buildSummaryRow(Icons.timer, 'Trip Duration', '42 min'),
                  _buildSummaryRow(Icons.inventory_2, 'Loading Time', '15 min'),
                  _buildSummaryRow(Icons.local_shipping, 'Unloading Time', '10 min'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildLocationTimeline(),
            const SizedBox(height: 48),
            CustomButton(
              text: 'COLLECT PAYMENT',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: DriverColors.primary),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: DriverColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLocationTimeline() {
    return Column(
      children: [
        _buildTimelineItem(Icons.my_location, 'Pickup', 'Industrial Area 4, Sharjah', true),
        _buildTimelineItem(Icons.location_on, 'Destination', 'Business Bay, Dubai', false),
      ],
    );
  }

  Widget _buildTimelineItem(IconData icon, String label, String address, bool isFirst) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: isFirst ? DriverColors.accent : DriverColors.error),
            if (isFirst)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: DriverColors.textSecondary)),
              Text(address, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
