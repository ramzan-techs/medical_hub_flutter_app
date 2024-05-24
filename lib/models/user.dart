class User {
  late final String id;
  late final String name;
  late final String email;
  late final String imageUrl;
  late final String phoneNumber;
  late final bool isPhoneHidden;
  late final bool isOnline;
  late final String createdAt;
  late final String lastActive;
  late final List<String> likes;
  late final bool isUpdated;

  // New properties
  late final String state;
  late final String address;
  late final String city;
  late final bool gender;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.imageUrl,
      required this.phoneNumber,
      required this.isPhoneHidden,
      required this.createdAt,
      // New constructor parameters
      required this.state,
      required this.address,
      required this.gender,
      required this.city,
      required this.isOnline,
      required this.lastActive,
      required this.likes,
      required this.isUpdated});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        imageUrl: json['imageUrl'] ?? "",
        phoneNumber: json['phoneNumber'] ?? "",
        isPhoneHidden: json['isPhoneHidden'] ?? true,
        isUpdated: json['isUpdated'] ?? true,
        createdAt: json['createdAt'] ?? "",
        lastActive: json['lastActive'] ?? false,
        // New properties from JSON
        state: json['state'] ?? "",
        address: json['address'] ?? "",
        gender: json['gender'] ?? false,
        city: json['city'] ?? "",
        isOnline: json['isOnline'] ?? false,
        likes: List<String>.from(json['likes']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'isPhoneHidden': isPhoneHidden,
      'createdAt': createdAt,
      'lastActive': lastActive,
      // New properties to JSON
      'state': state,
      'address': address,
      'gender': gender,
      'city': city,
      'isOnline': isOnline,
      'likes': likes,
      'isUpdated': isUpdated
    };
  }
}
