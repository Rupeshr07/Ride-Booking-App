import 'package:ride_booking/customer_app/models/user_model.dart';
import 'vehicle_model.dart';

enum BookingStatus {
  pending,
  assigned,
  started,
  completed,
  cancelled,
}

class BookingModel {
  final String id;
  final UserModel user;
  final VehicleModel vehicle;
  final String pickupLocation;
  final String dropoffLocation;
  final double distance;
  final double totalFare;
  final BookingStatus status;
  final String? otp;
  final DateTime? createdAt;

  BookingModel({
    required this.id,
    required this.user,
    required this.vehicle,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.totalFare,
    this.status = BookingStatus.pending,
    this.otp,
    this.createdAt,
  });

  // Mock data generator
  static List<BookingModel> historyMocks() {
    final user = UserModel.mock();
    final vehicles = VehicleModel.mocks();
    
    return [
      BookingModel(
        id: 'b1',
        user: user,
        vehicle: vehicles[0],
        pickupLocation: 'Warehouse 14, Industrial Estate North',
        dropoffLocation: 'City Center Retail Hub, Block C',
        distance: 4.5,
        totalFare: 32.50,
        status: BookingStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      BookingModel(
        id: 'b2',
        user: user,
        vehicle: vehicles[1],
        pickupLocation: 'Express Cargo Terminal',
        dropoffLocation: 'Downtown Logistics Hub',
        distance: 5.2,
        totalFare: 32.50,
        status: BookingStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      BookingModel(
        id: 'b3',
        user: user,
        vehicle: vehicles[0],
        pickupLocation: 'Express Cargo Terminal',
        dropoffLocation: 'Downtown Logistics Hub',
        distance: 6.0,
        totalFare: 44.00,
        status: BookingStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
