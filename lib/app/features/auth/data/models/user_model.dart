import 'package:syncup/app/core/constants/typedefs.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final bool isPlatformOwner;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.isPlatformOwner,
  });

  factory UserModel.fromJson(Json json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['name']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      isPlatformOwner: json['isPlatformOwner'] == true,
    );
  }

  Json toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'isPlatformOwner': isPlatformOwner,
    };
  }
}

class AuthResponseModel {
  final UserModel user;
  final String accessToken;
  final String? refreshToken;

  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Json json) {
    final userJson = json['user'] is Map<String, dynamic>
        ? json['user'] as Json
        : json;
    return AuthResponseModel(
      user: UserModel.fromJson(userJson),
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString(),
    );
  }
}
