/// Represents a response object for a login request.
class LoginResponse {
  /// The refresh token received in the login response.
  final String refreshToken;

  /// The access token (JWT token) received in the login response.
  final String token;

  /// A message associated with the login response.
  final String message;

  /// Constructs a LoginResponse object with the given parameters.
  const LoginResponse({
    required this.refreshToken,
    required this.token,
    required this.message,
  });

  /// Creates a LoginResponse object from a JSON map.
  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      refreshToken: map['refreshToken']?.toString() ?? '',
      token: map['token']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
    );
  }
}
