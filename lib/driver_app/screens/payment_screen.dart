import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ride_provider.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Collect Payment'),
          backgroundColor: Colors.white,
          foregroundColor: DriverColors.textPrimary,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Amount to Collect',
                style: TextStyle(fontSize: 16, color: DriverColors.textSecondary),
              ),
              const Text(
                '\$125.00',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: DriverColors.primary),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Customer can scan this QR to pay',
                      style: TextStyle(fontSize: 14, color: DriverColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[100],
                      child: const Center(
                        child: Icon(Icons.qr_code_2, size: 150, color: DriverColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'TRX ID: ARC-98723451',
                      style: TextStyle(fontSize: 12, color: DriverColors.textSecondary, fontFeatures: [FontFeature.tabularFigures()]),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: DriverColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('CASH RECEIVED'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'CONFIRM PAYMENT',
                      onPressed: () {
                        context.read<RideProvider>().confirmPayment();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
