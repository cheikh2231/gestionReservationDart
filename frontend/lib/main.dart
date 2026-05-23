import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prbd_2526_a04/core/tools/params.dart';
import 'package:prbd_2526_a04/core/widgets/mockup_carousel_screen.dart';

void main() async {
  await Params.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carousel des mockups',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MockupCarouselScreen(),
    ),
  );
}
