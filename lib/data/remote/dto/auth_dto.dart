import '../../../domain/model/auth_models.dart';

class LoginRequestDto {
  final String username;
  final String password;

  const LoginRequestDto({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class AuthTokensDto {
  final String access;
  final String refresh;

  const AuthTokensDto({required this.access, required this.refresh});

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) {
    final access = json['access'];
    final refresh = json['refresh'];

    if (access is! String || refresh is! String) {
      throw const FormatException(
        'La respuesta del servidor no contiene tokens válidos.',
      );
    }

    return AuthTokensDto(access: access, refresh: refresh);
  }

  AuthTokens toDomain() {
    return AuthTokens(access: access, refresh: refresh);
  }
}
