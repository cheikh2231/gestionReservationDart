import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reservation.dart';
import '../providers/security_provider.dart';
import '../views/pages/home_client_mockup.dart';
import '../views/pages/login_mockup.dart';
import '../views/pages/my_restaurants_mockup.dart';
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
      initialRoute: securityNotifier.isLoggedIn ? (securityNotifier.loggedRole=='client' ?'/home':'/my_restaurants') : '/login',
      routes: {
        '/login': (context) => LoginMockupScreen(),
        '/home': (context) => HomeClientMockupScreen(),
        '/my_reservations': (context) => HomeClientMockupScreen(),
        '/search_resto': (context) => SearchRestaurantsMockupScreen(),
        '/signup': (context) => SignupMockupScreen(),
        '/reservation_details': (context) => ReservationDetailsMockupScreen(),
        '/my_restaurants': (context) => MyRestaurantsMockupScreen(),
      },
    );
  }
}