import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/security_provider.dart';
import '../views/pages/home_client_mockup.dart';
import '../views/pages/login_mockup.dart';
import '../views/pages/reservation_details_mockup.dart';
import '../views/pages/search_restaurants_mockup.dart';
import '../views/pages/signup_mockup.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityNotifier = ref.read(securityProvider.notifier);
    return MaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: securityNotifier.isLoggedIn ? '/login' : '/home', //j'ai inversé pour le test
      routes: {
        '/login': (context) => LoginMockupScreen(),
        '/home': (context) => HomeClientMockupScreen(),
        '/register': (context) => SignupMockupScreen(),
        '/my_reservations': (context) => HomeClientMockupScreen(),
        '/edit_reservation': (context) => ReservationDetailsMockupScreen(),
        '/search_resto': (context) => SearchRestaurantsMockupScreen(),
      },
    );
  }
}