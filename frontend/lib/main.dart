import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/core/tools/params.dart';

import 'app/my_app.dart';
import 'package:prbd_2526_a04/providers/my_provider_observer.dart';


void main() async {
  await Params.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(
    ProviderScope(
      observers: [MyProviderObserver()],
      retry: (int _, Object _) => null,
      child: const MyApp(),
    ),
  );
}
