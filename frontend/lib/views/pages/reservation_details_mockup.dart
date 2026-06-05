import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/core/widgets/reservations_details_card.dart';
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
  final simulatedTime = DateTime(2024, 12, 4, 16, 0);

  bool canTouch(Reservation res) {
    return res.status != "cancelled" && res.status != "completed";
  }
  bool canMod(Reservation res) {
    // return canTouch(res) && res.datetime.isAfter(simulatedTime);
    return true;
  }

  Future<void> _onCancelPressed() async {
    final action = await DialogBox(
      title: 'Annuler la réservation',
      message: 'Êtes-vous sûr de vouloir annuler cette réservation ?',
      actions: const ['Retour', 'Confirmer'],
    ).show(context);

    if (action != 'Confirmer') return;

    final id = ModalRoute.of(context)!.settings.arguments as int;
    final reservation = await ref.watch(reservationsProvider.notifier).cancelReservation(id);
    final success = reservation != null;
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
    final id = ModalRoute.of(context)!.settings.arguments as int;
    final reservationsAsync = ref.watch(reservationsProvider);

    final reservation = reservationsAsync.value?.firstWhere((r) => r.id == id);
    final theme = Theme.of(context);
    if(reservationsAsync.isLoading){
        return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Détails de la réservation'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir les données',
            onPressed: () {
              ref.read(reservationsProvider.notifier).refresh();
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
              ReservationDetailCard(reservation: reservation! ),
              const SizedBox(height: 24),
              if(canTouch(reservation))
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                    onPressed: !canMod(reservation) ? null :() {
                      Navigator.pushNamed(
                      context,
                      '/add_edit_reservation', arguments: {'reservation': reservation},
                      );
                    },
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
