import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/core/widgets/reservations_details_card.dart';

import '../../core/services/api_client.dart';
import '../../core/widgets/dialog_box.dart';
import '../../models/reservation.dart';
import '../../providers/reservation_provider.dart';

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
  Reservation? _reservation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)?.settings.arguments;
    if (id != null) _loadReservation(id as int);
  }

  bool canMod(Reservation res) {
    return res.status != "cancelled" && res.status != "completed";
  }

  Future<void> _loadReservation(int id) async {
    final response = await ApiClient.get('get_reservation?id_res=$id');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _reservation = Reservation.fromJson(data.first);
        _loading = false;
      });
    }
  }

  Future<bool> _cancelReservation(int id) async{
    final response = await ApiClient.post(
        'cancel_reservation',
        body: jsonEncode({'id_res': id})
   );
    if(response.statusCode == 200){
      final List<dynamic> list = jsonDecode(response.body);
      final updated = Reservation.fromJson(list.first);
      setState(() {
        _reservation = updated;
        _loading = false;
      });
      ref.read(reservationsProvider.notifier).updateReservation(updated);
    }

    return response.statusCode == 200;
  }

  Future<void> _onCancelPressed() async {
    final action = await DialogBox(
      title: 'Annuler la réservation',
      message: 'Êtes-vous sûr de vouloir annuler cette réservation ?',
      actions: const ['Retour', 'Confirmer'],
    ).show(context);

    if (action != 'Confirmer') return;

    final id = ModalRoute.of(context)!.settings.arguments as int;
    final success = await _cancelReservation(id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Réservation annulée avec succès'
            : 'Erreur lors de l\'annulation.'),
        backgroundColor: success ? Colors.red : Theme.of(context).colorScheme.error,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final simulatedTime = DateTime(2024, 12, 4, 16, 0);
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
            onPressed: () {
              final id = ModalRoute.of(context)!.settings.arguments as int;
              _loadReservation(id);
            },
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
              _loading ? const Center(child: CircularProgressIndicator()) :
              ReservationDetailCard(reservation: _reservation!),
              const SizedBox(height: 24),
              if(canMod(_reservation!))
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
                     onPressed: () {
                        _onCancelPressed();
                      },
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
