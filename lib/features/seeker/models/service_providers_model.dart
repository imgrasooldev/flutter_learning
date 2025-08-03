class ServiceProvider {
  final int id;
  final int? userId;
  final String title;
  final int? categoryId;
  final int subcategoryId;
  final int areaId;
  final String experience;
  final List<String> availableDays;
  final String availableTime;
  final User user;
  final Category category;
  final Area area;

  ServiceProvider({
    required this.id,
    required this.userId,
    required this.title,
    required this.categoryId,
    required this.subcategoryId,
    required this.areaId,
    required this.experience,
    required this.availableDays,
    required this.availableTime,
    required this.user,
    required this.category,
    required this.area,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      categoryId: json['category_id'] ?? 0,
      subcategoryId: json['subcategory_id'] ?? 0,
      areaId: json['area_id'] ?? 0,
      experience: json['experience'] ?? '',
      availableDays:
          json['available_days'] != null
              ? List<String>.from(json['available_days'])
              : [],
      availableTime: json['available_time'] ?? '',
      user:
          json['user'] != null
              ? User.fromJson(json['user'])
              : User(id: 0, name: 'Unknown', email: ''),
      category:
          json['category'] != null
              ? Category.fromJson(json['category'])
              : Category(id: 0, name: 'Unknown'),
      area:
          json['area'] != null
              ? Area.fromJson(json['area'])
              : Area(id: 0, name: 'Unknown'),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? phone; // <-- ADD THIS
  final int? cityId; // <-- ADD THIS
  final String? bio; // <-- ADD THIS

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.cityId,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'], // <-- Add this line
      cityId: json['city_id'], // <-- Add this line
      bio: json['bio'], // <-- Add this line
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}

class Area {
  final int id;
  final String name;

  Area({required this.id, required this.name});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(id: json['id'], name: json['name']);
  }
}
