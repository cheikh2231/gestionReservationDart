import 'package:prbd_2526_a04/core/services/security.dart';

class User {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final String role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      role:  json['role']
    );
  }
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'L\'adresse email est requise';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Format d\'email invalide';
    }
    return null;
  }

  static Future<String?> validateEmailUnicity(String? value) async {
    var res = await Security.checkEmailAvailable(email: value?.trim());
    return res ? null : 'Cet email est déjà utilisé';
  }

  static String? validateFullName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Le nom complet est requis';
    }
    if (name.trim().length < 3) {
      return 'Doit contenir au moins 3 caractères';
    }
    return null;
  }

  static Future<String?> validateFullNameUnicity(String? value) async {
    if (value == null || value.trim().isEmpty) return null;
    var res = await Security.checkFullNameAvailable(fullName: value.trim());
    return res ? null : 'Ce nom d\'utilisateur est déjà pris';
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Le mot de passe est requis';
    if (value.length < 8) return 'Doit contenir au moins 8 caractères';

    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Au moins une majuscule requise';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Au moins une minuscule requise';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Au moins un chiffre requis';
    if (!RegExp(r'[,;.:!?/$%&@#]').hasMatch(value)) {
      return 'Au moins un caractère spécial requis (,;.:!?/\$%&@#)';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    String? passwordError = validatePassword(value);
    if (passwordError != null) return passwordError;
    if (value != password) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final regex = RegExp(r'^\+32[ ]?([1-9]\d{0,2})[ ]?(\d{2}[ ]?\d{2}[ ]?\d{2}|\d{3}[ ]?\d{2}[ ]?\d{2})$');
    if (!regex.hasMatch(value)) {
      return 'Format invalide (ex: +32 470 12 34 56)';
    }
    return null;
  }

}