class UserProfile {
  final int id;
  final String phoneNumber;
  final String name;
  final String gender;
  final String email;
  final String? profileImage;

  UserProfile({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.gender,
    required this.email,
    this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'gender': gender,
      'email': email,
      'profileImage': profileImage,
    };
  }
}
