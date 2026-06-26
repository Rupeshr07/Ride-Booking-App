import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ride_provider.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: DriverColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 60),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Payment Success!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DriverColors.textPrimary),
                ),
                const SizedBox(height: 16),
                const Text(
                  'The payment of \$125.00 has been successfully received from James Carter.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: DriverColors.textSecondary),
                ),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: DriverColors.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Transaction ID', style: TextStyle(color: DriverColors.textSecondary)),
                      Text('ARC-98723451', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                CustomButton(
                  text: 'RETURN TO HOME',
                  onPressed: () {
                    context.read<RideProvider>().returnToHome();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
