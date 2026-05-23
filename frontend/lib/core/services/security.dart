import 'dart:convert';

import 'package:prbd_2526_a04/core/services/api_client.dart';

class Security {

  static Future<String?> login(String email, String password) async {
    final response = await ApiClient.post(
      'login',
      body: json.encode({'email': email, 'password': password}),
      anonymous: true,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to login');
    }
    final dynamic body = json.decode(response.body);
    String token = body['token'];
    return token;
  }

  static Future<bool> checkEmailAvailable({String? email}) async {
    final response = await ApiClient.post(
      'is_email_available',
      body: json.encode({'email': email}),
      anonymous: true,
    );
    final dynamic body = json.decode(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to validate email\n\n${body['message']}');
    }
    return body;
  }

  static Future<void> signup({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final response = await ApiClient.post(
      'signup',
      body: json.encode({
        'email': email,
        'password': password,
        'full_name': fullName,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      }),
      anonymous: true,
    );
    if (response.statusCode != 200) {
      final dynamic body = json.decode(response.body);
      throw Exception('Failed to signup\n\n${body['message']}');
    }
  }
}