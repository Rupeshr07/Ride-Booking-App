class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String? profileImage;
  final String? email;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.profileImage,
    this.email,
  });

  // Mock data generator
  static UserModel mock() {
    return UserModel(
      id: 'user_1',
      name: 'John Doe',
      phoneNumber: '+91 9876543210',
      profileImage: 'https://i.pravatar.cc/300',
      email: 'john.doe@example.com',
    );
  }
}
