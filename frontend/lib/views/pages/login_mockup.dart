import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prbd_2526_a04/providers/security_provider.dart';
import 'package:prbd_2526_a04/models/user.dart';
import 'package:prbd_2526_a04/core/tools/validating_text_editing_controller.dart';
import 'package:prbd_2526_a04/core/widgets/dialog_box.dart';

import '../../core/services/security.dart';
import '../../providers/reservation_provider.dart';
import '../../core/widgets/simulated_time_display.dart';
import '../../providers/system_time_provider.dart';

class LoginMockupScreen extends ConsumerStatefulWidget {
  const LoginMockupScreen({super.key});

  @override
  ConsumerState<LoginMockupScreen> createState() => _LoginMockupScreenState();
}

class _LoginMockupScreenState extends ConsumerState<LoginMockupScreen> {
  final _emailController = ValidatingTextEditingController(
    validator: User.validateEmail,
    initialValue: '',
  );

  final _passwordController = ValidatingTextEditingController(
    validator: (value) => value == null || value.isEmpty ? 'Le mot de passe est requis' : null,
    initialValue: '',
  );

  bool _obscurePassword = true; // afficher ou cacher le mot de passe

  @override
  void initState() {
    _emailController.onAfterValidated = () => setState(() {});
    _passwordController.onAfterValidated = () => setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
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
        flexibleSpace: const SimulatedTimeDisplay(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      const Icon(
                        Icons.restaurant,
                        size: 80,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Connectez-vous',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        autofocus: true,
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
                      const SizedBox(height: 10),
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
                        onFieldSubmitted: (_) => _submitForm(context),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Se connecter'),
                      ),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed:() {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          'Pas encore de compte ? S\'inscrire',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Raccourcis de débogage',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Se connecter directement en tant que :',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _login(context, 'brlacroix@epfc.eu', password: 'Password1,'),
                          icon: const Icon(Icons.person),
                          label: const Text('Client (Bruno)'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _login(context, 'mamichel@epfc.eu', password: 'Password1,'),
                          icon: const Icon(Icons.person),
                          label: const Text('Client (Marc)'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _login(context, 'bepenelle@epfc.eu', password: 'Password1,'),
                          icon: const Icon(Icons.manage_accounts),
                          label: const Text('Manager (Benoît)'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _login(context, 'gedielman@epfc.eu', password: 'Password1,'),
                          icon: const Icon(Icons.manage_accounts),
                          label: const Text('Manager (Geoffrey)'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final action = await DialogBox(
                          title: 'Réinitialiser la base de données',
                          message: 'Êtes-vous sûr de vouloir réinitialiser la base de données ? Cette action supprimera toutes les données et les restaurera aux valeurs par défaut.',
                          actions: const ['Annuler', 'Réinitialiser'],
                        ).show(context);

                        if (action == 'Réinitialiser') {
                          final success = await Security.resetDatabase();

                          if (!context.mounted) return;

                          if (success) {

                            ref.invalidate(systemTimeProvider);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Base de données réinitialisée avec succès'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Erreur lors de la réinitialisation.'),
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réinitialiser la base de données'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _submitForm(BuildContext context) {
    if (!_validateForm()) return;
    _login(context, _emailController.text, password: _passwordController.text);
  }

  bool _validateForm() {
    _emailController.validate();
    _passwordController.validate();
    return _isFormValid;
  }

  bool get _isFormValid =>
      _emailController.isValid == true && _passwordController.isValid == true;

  void _login(BuildContext context, String mail, {String? password}) async {
    await ref.read(securityProvider.notifier).login(mail, password ?? mail);
    var securityState = ref.read(securityProvider);

    if (!context.mounted) return;

    securityState.when(
      data: (_) {
        final role = ref
            .read(securityProvider.notifier)
            .loggedRole;
        if (role == 'manager') {
          Navigator.pushReplacementNamed(context, '/my_restaurants');
          print("✅ Connexion Manager réussie !");
        } else {
          Navigator.pushReplacementNamed(context, '/home');
          print("✅ Connexion Client réussie !");
        }
      },
      error: (error, _) {
        DialogBox(
          title: 'Erreur de connexion',
          message: 'Email et/ou mot de passe incorrect !',
          actions: ['OK'],
        ).show(context);
      },
      loading: () {}, // Ne rien faire, le bouton affiche déjà le chargement
    );
  }
}
