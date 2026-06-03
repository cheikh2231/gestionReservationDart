import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prbd_2526_a04/providers/security_provider.dart';
import 'package:prbd_2526_a04/models/user.dart';
import 'package:prbd_2526_a04/core/tools/validating_text_editing_controller.dart';
import 'package:prbd_2526_a04/core/widgets/dialog_box.dart';

class SignupMockupScreen extends ConsumerStatefulWidget {
  const SignupMockupScreen({super.key});

  @override
  ConsumerState<SignupMockupScreen> createState() => _SignupMockupScreenState();
}

class _SignupMockupScreenState extends ConsumerState<SignupMockupScreen> {
  final _fullNameController = ValidatingTextEditingController(
    validator: User.validateFullName,
    initialValue: '',
  );

  final _emailController = ValidatingTextEditingController(
    validator: User.validateEmail,
    asyncValidator: User.validateEmailUnicity,
    initialValue: '',
  );

  final _passwordController = ValidatingTextEditingController(
    validator: User.validatePassword,
    initialValue: '',
  );

  late final ValidatingTextEditingController _confirmPasswordController;

  final _phoneController = ValidatingTextEditingController(
    validator: User.validatePhone, // --- On utilise ta nouvelle méthode ici ! ---
    initialValue: '',
  );

  bool _obscurePassword = true;

  @override
  void initState() {
    _confirmPasswordController = ValidatingTextEditingController(
      validator: (value) => User.validateConfirmPassword(value, _passwordController.text),
      initialValue: '',
    );

    _fullNameController.onAfterValidated = () => setState(() {});
    _emailController.onAfterValidated = () => setState(() {});
    _passwordController.onAfterValidated = () => setState(() {});
    _confirmPasswordController.onAfterValidated = () => setState(() {});
    _phoneController.onAfterValidated = () => setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final simulatedTime = DateTime(2024, 12, 4, 16, 0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Inscription'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir les données',
            onPressed: () {},
          ),
        ],
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Tooltip(
                message:
                    'Date/heure simulée utilisée pour les tests.\nCliquez pour modifier.',
                child: Text(
                  DateFormat('EEEE dd/MM/yyyy HH:mm', 'fr_FR')
                      .format(simulatedTime),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Icon(Icons.person_add, size: 80, color: Colors.blue),
                const SizedBox(height: 32),
                const Text(
                  'Créez votre compte',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _fullNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Nom complet',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                    errorText: _fullNameController.errorText,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                    errorText: _emailController.errorText,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    errorText: _passwordController.errorText,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    errorText: _confirmPasswordController.errorText,
                  ),
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Téléphone (optionnel)',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                    errorText: _phoneController.errorText,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('S\'inscrire'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    },
                  child: const Text('Déjà un compte ? Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!await _validateForm()) return;
    _signup(context);
  }

  Future<bool> _validateForm() async {
    await _fullNameController.validateAndWait();
    await _emailController.validateAndWait();
    await _passwordController.validateAndWait();
    await _confirmPasswordController.validateAndWait();
    await _phoneController.validateAndWait();
    return _isFormValid;
  }

  bool get _isFormValid =>
      _fullNameController.isValid == true &&
          _emailController.isValid == true &&
          _passwordController.isValid == true &&
          _confirmPasswordController.isValid == true &&
          _phoneController.isValid == true;

  void _signup(BuildContext context) async {
    try {
      await ref.read(securityProvider.notifier).signup(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription réussie !'), backgroundColor: Colors.green),
      );
      Navigator.pushReplacementNamed(context, '/home');

    } catch (e) {
      if (!context.mounted) return;
      DialogBox(
        title: "Erreur d'inscription",
        message: "L'inscription a pu réussir, mais la connexion automatique a échoué.",
        actions: const ['OK'],
      ).show(context);
    }
  }
}
