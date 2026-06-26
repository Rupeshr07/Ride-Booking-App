class DriverModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String? vehicleNo;
  final bool? isOnline;

  DriverModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.vehicleNo,
    this.isOnline,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      vehicleNo: json['vehicleNo'],
      isOnline: json['isOnline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'vehicleNo': vehicleNo,
      'isOnline': isOnline,
    };
  }
}
