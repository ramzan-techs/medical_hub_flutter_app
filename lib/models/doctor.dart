class Doctor {
  late final String id;
  late final String registrationNumber;
  late final String name;
  late final String speciality;
  late final String profileImageUrl;
  late final String email;
  late final int favoritesCount;
  // late final List<String> availableDays;
  // late final Map<String, List<String>> availableTimes;
  late final bool isOnline;
  late final String createdAt;
  late final String lastActive;
  late final String phone;
  late final bool gender;
  late final String state;
  late final String city;
  late final String address;
  late final String cnicImageUrl;
  late final String licenseImageUrl;
  late final String qualification;
  late final bool isUpdated;
  late final bool isReviewed;
  late final bool isApproved;
  late final List<String> availableDays;
  late final List<String> availableTime;

  Doctor(
      {required this.id,
      required this.registrationNumber,
      required this.name,
      required this.speciality,
      required this.profileImageUrl,
      required this.email,
      required this.favoritesCount,
      // required this.availableDays,
      // required this.availableTimes,
      required this.isOnline,
      required this.createdAt,
      required this.lastActive,
      required this.phone,
      required this.gender,
      required this.state,
      required this.city,
      required this.address,
      required this.cnicImageUrl,
      required this.licenseImageUrl,
      required this.qualification,
      required this.isUpdated,
      required this.isReviewed,
      required this.isApproved,
      required this.availableDays,
      required this.availableTime});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
        id: json['id'],
        registrationNumber: json['registrationNumber'] ?? "",
        name: json['name'],
        speciality: json['speciality'] ?? "",
        profileImageUrl: json['profileImageUrl'] ?? "",
        email: json['email'] ?? "",
        favoritesCount: json['favoritesCount'] ?? 0,
        // availableDays: List<String>.from(json['availableDays']),
        // availableTimes: Map<String, List<String>>.from(json['availableTimes']),
        isOnline: json['isOnline'] ?? true,
        createdAt: json['createdAt'] ?? "",
        lastActive: json['lastActive'] ?? "",
        phone: json['phone'] ?? "",
        gender: json['gender'] ?? false,
        isUpdated: json['isUpdated'] ?? false,
        isReviewed: json['isReviewed'] ?? false,
        isApproved: json['isApproved'] ?? false,
        state: json['state'] ?? "",
        city: json['city'] ?? "",
        address: json['address'] ?? "",
        cnicImageUrl: json['cnicImageUrl'] ?? "",
        licenseImageUrl: json['licenseImageUrl'] ?? "",
        qualification: json['qualification'] ?? "",
        availableDays: List<String>.from(json['availableDays']),
        availableTime: List<String>.from(json['availableTime']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'name': name,
      'specialty': speciality,
      'profileImageUrl': profileImageUrl,
      'email': email,
      'favoritesCount': favoritesCount,
      // 'availableDays': availableDays,
      // 'availableTimes': availableTimes,
      'isOnline': isOnline,
      'createdAt': createdAt,
      'lastActive': lastActive,
      'phone': phone,
      'gender': gender,
      'state': state,
      'city': city,
      'address': address,
      'cnicImageUrl': cnicImageUrl,
      'licenseImageUrl': licenseImageUrl,
      'qualification': qualification,
      'isUpdated': isUpdated,
      'isReviewed': isReviewed,
      'isApproved': isApproved,
      'availableDays': availableDays,
      'availableTime': availableTime
    };
  }
}
