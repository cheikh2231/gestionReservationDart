import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/core/tools/params.dart';
import 'package:prbd_2526_a04/core/widgets/mockup_carousel_screen.dart';
import 'package:prbd_2526_a04/views/pages/login_mockup.dart';
import 'package:prbd_2526_a04/views/pages/my_restaurants_mockup.dart';

import 'core/services/security.dart';

void main() async {
  await Params.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  // --- connexion réalisé a chaque lancement --
  try {
    String? token = await Security.login('bepenelle@epfc.eu', 'Password1,');

    if (token != null) {
      Params.setValue('token', token);
      print("Auto-connexion réussie");
    }
  } catch (e) {
    print("Échec de l'auto-connexion : $e");
  }
  // --------------------------------------------
  runApp(
    ProviderScope(
      // observers: [MyProviderObserver()],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carousel des mockups',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/myrestaurants',

      routes: {
        '/myrestaurants': (context) => const MyRestaurantsMockupScreen(),
        '/login': (context) => const LoginMockupScreen(),
      },
      // home: const MockupCarouselScreen(),
    );
  }
}
