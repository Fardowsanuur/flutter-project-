import 'package:get_storage/get_storage.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();
  final storage = GetStorage();
  final String _tokenKey = 'token';

  // Singleton constructor
  factory TokenService() {
    return _instance;
  }

  TokenService._internal();

  /// Get token
  String? getToken() {
    return storage.read(_tokenKey);
  }

  // Set token
  Future<void> setToken(String token) async {
    await storage.write(_tokenKey, token);
  }

  // Remove token
  Future<void> removeToken() async {
    await storage.remove(_tokenKey);
  }

  // Check if token exists
  bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}
