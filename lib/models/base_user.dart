class BaseUser {
  late final String id;
  late final String name;
  late final UserType userType;
  late final String createdAt;
  late final String email;

  BaseUser(
      {required this.id,
      required this.name,
      required this.userType,
      required this.createdAt,
      required this.email});

  BaseUser.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    userType = json['user_type'].toString() == UserType.user.name
        ? UserType.user
        : UserType.doctor;
    createdAt = json['created_at'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_type'] = userType.name;
    data['created_at'] = createdAt;
    data['email'] = email;
    return data;
  }
}

enum UserType { user, doctor }
