import 'dart:convert';

class UserModel {
  final String email;
  final String name;
  final String photoUrl;
  final String uid;
  final String token;
  UserModel({
    required this.email,
    required this.name,
    required this.photoUrl,
    required this.uid,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'uid': uid,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      uid: map['_id'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? email,
    String? name,
    String? photoUrl,
    String? uid,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      token: token ?? this.token,
    );
  }
}