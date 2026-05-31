import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reservation.dart';
import '../providers/security_provider.dart';
import '../views/pages/home_client_mockup.dart';
import '../views/pages/login_mockup.dart';
import '../views/pages/my_restaurants_mockup.dart';
import '../views/pages/reservation_details_mockup.dart';
import '../views/pages/reservation_form_mockup.dart';
import '../views/pages/restaurant_details_mockup.dart';
import '../views/pages/search_restaurants_mockup.dart';
import '../views/pages/signup_mockup.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityNotifier = ref.read(securityProvider.notifier);
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
        ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),


      initialRoute: securityNotifier.isLoggedIn ? (securityNotifier.loggedRole=='client' ?'/home':'/my_restaurants') : '/login',
      routes: {
        '/login': (context) => LoginMockupScreen(),
        '/home': (context) => HomeClientMockupScreen(),
        '/my_reservations': (context) => HomeClientMockupScreen(),
        '/search_resto': (context) => SearchRestaurantsMockupScreen(),
        '/signup': (context) => SignupMockupScreen(),
        '/reservation_details': (context) => ReservationDetailsMockupScreen(),
        '/add_edit_reservation': (context) => ReservationFormMockupScreen(),
        '/my_restaurants': (context) => MyRestaurantsMockupScreen(),
        '/restaurant_details': (context) => RestaurantDetailsMockupScreen()
      },
    );
  }
}