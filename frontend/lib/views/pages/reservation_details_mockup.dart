import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/core/widgets/reservations_details_card.dart';

import '../../models/reservation.dart';
import '../../models/reservation_client.dart';

void main() async {
  await initializeDateFormatting('fr_FR', null);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ReservationDetailsMockupScreen(),
    ),
  );
}

class ReservationDetailsMockupScreen extends ConsumerStatefulWidget {
  const ReservationDetailsMockupScreen({super.key});

  @override
  ConsumerState<ReservationDetailsMockupScreen> createState() =>
      _ReservationDetailsMockupState();
}

class _ReservationDetailsMockupState extends ConsumerState<ReservationDetailsMockupScreen> {
  bool _loading = true;
  ReservationDetails? _reservationDetails;
  @override
  void initState() {
    super.initState();
  }

  bool canMod(Reservation res) {
    return res.status != "cancelled" && res.status != "completed";
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;


    if (arg != null) {
       setState(() {
         _reservationDetails = arg as ReservationDetails;
         _loading = false;
       });
    }

    final theme = Theme.of(context);
    final simulatedTime = DateTime(2024, 12, 4, 16, 0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, '/my_reservations');
          },
        ),
        title: const Text('Détails de la réservation'),
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
                  DateFormat(
                    'EEEE dd/MM/yyyy HH:mm',
                    'fr_FR',
                  ).format(simulatedTime),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Ton bloc de chargement ou carte
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ReservationDetailCard(reservationDetails: _reservationDetails!),

              const SizedBox(height: 24),

              // 2. Ton bloc conditionnel (le "if" est ici un mot-clé Dart spécial)
              if (_reservationDetails != null && canMod(_reservationDetails!.base))
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifier'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.cancel),
                      label: const Text('Annuler'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );



  }


}
