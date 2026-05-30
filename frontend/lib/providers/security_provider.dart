import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:prbd_2526_a04/core/services/security.dart';
import 'package:prbd_2526_a04/core/tools/params.dart';

final securityProvider = AsyncNotifierProvider<SecurityNotifier, String?>(
      () => SecurityNotifier(),
);

class SecurityNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    state = AsyncData(Params.getValue('token'));
    return state.value;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      var token = await Security.login(email, password);
      Params.setValue('token', token);
      state = AsyncData(token);
    } catch (e, st) {
      state = AsyncError("Something went wrong!\nPlease try again later.", st);
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    state = const AsyncLoading();
    try {
      await Security.signup(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      await login(email, password);
    } catch (e, st) {
      state = AsyncValue.error("Signup failed", StackTrace.current);
    }
  }

  void logout() {
    Params.clearValue('token');
    state = AsyncData(null);
  }

  bool get isLoggedIn => loggedUser != null;

  String? get loggedUser {
    return _getUserFieldFromToken(state.value, 'sub');
  }

  String? get loggedRole {
    return _getUserFieldFromToken(state.value, 'role');
  }

  String? get loggedName {
    return _getNameFromToken(state.value);
  }

  static String? _getNameFromToken(String? token) {
    if (token == null) return null;
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['name'];
    } catch (e) {
      return null;
    }
  }

  static String? _getUserFieldFromToken(String? token, String field) {
    if (token == null) return null;
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken[field];
    } catch (e) {
      return null;
    }
  }
}