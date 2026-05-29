import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/security_provider.dart';
import '../views/pages/home_client_mockup.dart';
import '../views/pages/login_mockup.dart';
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
      initialRoute: securityNotifier.isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => LoginMockupScreen(),
        '/home': (context) => HomeClientMockupScreen(),
        '/signup': (context) => SignupMockupScreen(),

      },
    );
  }
}