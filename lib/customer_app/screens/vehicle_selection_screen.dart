import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 import '../models/vehicle_model.dart';
import '../utils/constants.dart';
import '../widgets/bottom_sheet_container.dart';
import '../widgets/custom_button.dart';

class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  String _selectedLoadType = 'Light';
  final List<VehicleModel> _vehicles = [
    VehicleModel(
      id: 'v1',
      type: 'Auto Rickshaw',
      description: 'Up to 100 kg',
      baseFare: 15.00,
      perKmRate: 10.0,
      capacity: 3,
    ),
    VehicleModel(
      id: 'v2',
      type: 'Magic',
      description: 'Up to 200 kg',
      baseFare: 12.50,
      perKmRate: 12.0,
      capacity: 6,
    ),
  ];
  VehicleModel? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = _vehicles[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Real Google Map
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 14.0,
            ),
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          
          // Header Location Card (Overlay on map)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.p20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTripLocationRow(
                      icon: Icons.radio_button_checked,
                      iconColor: const Color(0xFF1E293B),
                      label: 'PICKUP',
                      address: '1288 Howard St, San Francisco',
                      showLine: true,
                    ),
                    const SizedBox(height: 8),
                    _buildTripLocationRow(
                      icon: Icons.location_on,
                      iconColor: const Color(0xFF65A30D),
                      label: 'DROP-OFF',
                      address: 'Pier 39, Beach St & The Embarcadero',
                      showLine: false,
                    ),
                    const SizedBox(height: 8),

                    // _buildLocationRow(
                    //   icon: Icons.location_on,
                    //   iconColor: const Color(0xFF9333EA),
                    //   label: 'DROP LOCATION',
                    //   value: 'Where to?',
                    //   isHint: true,
                    // ),
                  ],
                ),
              ),
            ),
          ),
          
          // Vehicle Selection Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomSheetContainer(
              showHandle: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Load Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildLoadTypeOption(
                            'Light',
                            'Light Weight',
                            'Up to 100 kg',
                          ),
                        ),
                        Expanded(
                          child: _buildLoadTypeOption(
                            'Heavy',
                            'Heavy Weight',
                            '100+ kg (up to 250 kg)',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Vehicle',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '2 available options',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._vehicles.map((vehicle) => _buildVehicleCard(vehicle)),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Note: Loading/unloading is free for the first 15 minutes. Charges apply thereafter: ₹50 up to 45 minutes, and ₹100 up to 1 hour 15 minutes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Continue Booking',
                    onPressed: () {
                      Navigator.pushNamed(context, '/booking_confirmation');
                    },
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

  Widget _buildLoadTypeOption(String type, String title, String subtitle) {
    final isSelected = _selectedLoadType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLoadType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF334155) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildLocationRow({
  //   required IconData icon,
  //   required Color iconColor,
  //   required String label,
  //   required String value,
  //   bool showDashedLine = false,
  //   bool isHint = false,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF3F4F6),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Row(
  //       children: [
  //         Column(
  //           children: [
  //             Icon(icon, color: iconColor, size: 20),
  //             if (showDashedLine)
  //               Container(
  //                 width: 1,
  //                 height: 20,
  //                 margin: const EdgeInsets.symmetric(vertical: 4),
  //                 child: CustomPaint(
  //                   painter: _DashedLinePainter(color: Colors.grey.shade400),
  //                 ),
  //               ),
  //           ],
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 label,
  //                 style: const TextStyle(
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF9CA3AF),
  //                   letterSpacing: 0.5,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 value,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: isHint ? FontWeight.normal : FontWeight.w600,
  //                   color: isHint ? const Color(0xFF9CA3AF) : const Color(0xFF1F2937),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }




  Widget _buildTripLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String address,
    required bool showLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            if (showLine)
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 15,
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

  Widget _buildVehicleCard(VehicleModel vehicle) {
    final isSelected = _selectedVehicle?.id == vehicle.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVehicle = vehicle;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.local_shipping_outlined, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.type,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            vehicle.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${vehicle.baseFare.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 3, startY = 0;
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
