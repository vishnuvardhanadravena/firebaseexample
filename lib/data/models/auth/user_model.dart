

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;

  final String name;

  final String email;

  final String phone;

  final String profileImage;

  final bool isVerified;

  final String createdAt;

  final String updatedAt;

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json["id"] ?? 0,

      name: json["name"] ?? "",

      email: json["email"] ?? "",

      phone: json["phone"] ?? "",

      profileImage:
          json["profile_image"] ??
          json["profileImage"] ??
          "",

      isVerified:
          json["is_verified"] ??
          json["isVerified"] ??
          false,

      createdAt:
          json["created_at"] ??
          json["createdAt"] ??
          "",

      updatedAt:
          json["updated_at"] ??
          json["updatedAt"] ??
          "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "name": name,

      "email": email,

      "phone": phone,

      "profile_image": profileImage,

      "is_verified": isVerified,

      "created_at": createdAt,

      "updated_at": updatedAt,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    bool? isVerified,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,

      name: name ?? this.name,

      email: email ?? this.email,

      phone: phone ?? this.phone,

      profileImage:
          profileImage ?? this.profileImage,

      isVerified:
          isVerified ?? this.isVerified,

      createdAt:
          createdAt ?? this.createdAt,

      updatedAt:
          updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '''
UserModel(
  id: $id,
  name: $name,
  email: $email,
  phone: $phone,
)
''';
  }
}