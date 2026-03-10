class UserModel {
  final int? id;
  final String email;
  final String password;
  final String phone;
  final String role;
  final String nickname;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    required this.nickname,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "password": password,
      "phone": phone,
      "role": role,
      "nickname": nickname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
      email: map["email"],
      password: map["password"],
      phone: map["phone"],
      role: map["role"],
      nickname: map['nickname'],
    );
  }
}
