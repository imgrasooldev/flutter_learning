class UserModel {
  final String name;
  final String email;
  final String token;
  UserModel({required this.name, required this.email, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Check if 'user' exists inside the response
    final userData = json['user'];

    if (userData != null) {
      // From registration: token is in root, user is nested
      return UserModel(
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        token: json['token'] ?? '',
      );
    } else {
      // From login: all fields are directly inside data
      return UserModel(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        token: json['token'] ?? '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'token': token};
  }
}
