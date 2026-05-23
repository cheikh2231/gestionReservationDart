import 'package:prbd_2526_a04/core/services/security.dart';

class User {
  // --- Validation email ---
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'L\'adresse email est requise';
    }
    // Regex format email
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

  // --- Validation nom  ---
  static String? validateFullName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Le nom complet est requis';
    }
    if (name.trim().length < 3) {
      return 'Doit contenir au moins 3 caractères';
    }
    return null;
  }

  // --- Validation mot de passe ---
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Le mot de passe est requis';
    if (value.length < 8) return 'Doit contenir au moins 8 caractères';

    // Regex pour mot de passe
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
}