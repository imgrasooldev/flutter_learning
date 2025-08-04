class UserModel {
  final String name;
  final String email;
  final String token;
  final String? phone;
  final int? cityId;
  final String? bio;
  UserModel({
    required this.name,
    required this.email,
    required this.token,
    this.phone,
    this.cityId,
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'];

    if (userData != null) {
      return UserModel(
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        token: json['token'] ?? '',
        phone: userData['phone'],
        cityId:
            userData['city_id'] != null
                ? int.tryParse(userData['city_id'].toString())
                : null,
        bio: userData['bio'],
      );
    } else {
      return UserModel(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        token: json['token'] ?? '',
        phone: json['phone'],
        cityId:
            json['city_id'] != null
                ? int.tryParse(json['city_id'].toString())
                : null,
        bio: json['bio'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'token': token,
      'phone': phone,
      'city_id': cityId,
      'bio': bio,
    };
  }
}
