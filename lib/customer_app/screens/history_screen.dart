import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/preference_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> rideHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await PreferenceService.getRideHistory();
    if (history.isEmpty) {
      // Add mock data if empty for the first time
      final mockData = [
        {
          'vehicleType': 'Magic',
          'assetId': 'ARC-1142',
          'fare': '₹32.50',
          'pickup': 'Warehouse 14, Industrial Estate North',
          'dropoff': 'City Center Retail Hub, Block C',
          'loadingTime': '14 Min',
          'unloadingTime': '08 Min',
          'totalTime': '52 Min',
          'date': 'TODAY, 25 OCT'
        },
        {
          'vehicleType': 'Auto',
          'assetId': 'ARC-1142',
          'fare': '₹32.50',
          'pickup': 'Express Cargo Terminal',
          'dropoff': 'Downtown Logistics Hub',
          'loadingTime': '20 Min',
          'unloadingTime': '15 Min',
          'totalTime': '74 Min',
          'date': 'YESTERDAY, 24 OCT'
        }
      ];
      for (var ride in mockData) {
        await PreferenceService.saveRide(ride);
      }
      final updatedHistory = await PreferenceService.getRideHistory();
      if (mounted) {
        setState(() {
          rideHistory = updatedHistory;
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          rideHistory = history;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : rideHistory.isEmpty
                ? const Center(child: Text("No rides yet"))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.p20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          ...rideHistory.map((ride) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ride['date'] ?? 'RECENT RIDE',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildHistoryCard(
                                    vehicleType: ride['vehicleType'],
                                    assetId: ride['assetId'],
                                    fare: ride['fare'],
                                    pickup: ride['pickup'],
                                    dropoff: ride['dropoff'],
                                    loadingTime: ride['loadingTime'],
                                    unloadingTime: ride['unloadingTime'],
                                    totalTime: ride['totalTime'],
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              )),
                          const SizedBox(height: 100), // Space for bottom nav
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String vehicleType,
    required String assetId,
    required String fare,
    required String pickup,
    required String dropoff,
    required String loadingTime,
    required String unloadingTime,
    required String totalTime,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.local_shipping_outlined, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'ASSET ID: $assetId',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    fare,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'PAID',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPathRow(Icons.radio_button_checked, const Color(0xFF0369A1), 'PICKUP', pickup, true),
          const SizedBox(height: 4),
          _buildPathRow(Icons.near_me, const Color(0xFF84CC16), 'DROP-OFF', dropoff, false),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('LOADING', loadingTime),
              _buildStatItem('UNLOADING', unloadingTime),
              _buildStatItem('TOTAL TIME', totalTime, isHighlighted: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPathRow(IconData icon, Color iconColor, String label, String address, bool showLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: iconColor, size: 18),
            if (showLine)
              Container(
                width: 1,
                height: 20,
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: CustomPaint(
                  painter: _DashedLinePainter(color: Colors.grey.shade300),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? const Color(0xFF0369A1) : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 2, dashSpace = 2, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
