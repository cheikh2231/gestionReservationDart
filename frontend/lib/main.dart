import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/core/tools/params.dart';
import 'package:prbd_2526_a04/providers/my_provider_observer.dart';

import 'app/my_app.dart';

void main() async {
  await Params.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  // // --- connexion réalisé a chaque lancement --
  // try {
  //   String? token = await Security.login('bepenelle@epfc.eu', 'Password1,');
  //
  //   if (token != null) {
  //     Params.setValue('token', token);
  //     print("Auto-connexion réussie");
  //   }
  // } catch (e) {
  //   print("Échec de l'auto-connexion : $e");
  // }
  // // --------------------------------------------
  runApp(
    ProviderScope(
      // observers: [MyProviderObserver()],
      observers: [MyProviderObserver()],
      retry: (int _, Object _) => null,
      child: const MyApp(),
    ),
  );

}
