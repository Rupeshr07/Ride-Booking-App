class VehicleModel {
  final String id;
  final String type;
  final String description;
  final String? image;
  final double baseFare;
  final double perKmRate;
  final int capacity;
  final String? estimatedTime;

  VehicleModel({
    required this.id,
    required this.type,
    required this.description,
    this.image,
    required this.baseFare,
    required this.perKmRate,
    required this.capacity,
    this.estimatedTime,
  });

  // Mock data generator
  static List<VehicleModel> mocks() {
    return [
      VehicleModel(
        id: 'v1',
        type: 'Auto Rickshaw',
        description: 'Up to 3-4 kg',
        baseFare: 14.00,
        perKmRate: 10.0,
        capacity: 3,
        estimatedTime: '4 Min',
      ),
      VehicleModel(
        id: 'v3',
        type: 'Magic',
        description: 'Up to 200 kg',
        baseFare: 15.50,
        perKmRate: 15.0,
        capacity: 4,
        estimatedTime: '5 Min',
      ),
    ];
  }
}
