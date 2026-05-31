import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/providers/system_time_provider.dart';
import '../../models/reservation_restaurant.dart';


class ReservationDetailsManagerMockupScreen extends ConsumerWidget {
  const ReservationDetailsManagerMockupScreen({super.key, required this.reservationWithUser});
  final ReservationWithUser reservationWithUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulatedTimeState = ref.watch(systemTimeProvider);
    final theme = Theme.of(context);
    final Map<String, ({Color color, bool btnConfirm, String? btnConfirmText, IconData? icon, bool btnCancelled})> statusManager = {
      'pending': (color: const Color(0xFFFB8C00), btnConfirm: true, btnConfirmText: "Confirmer et assigner tables", icon: Icons.restaurant, btnCancelled: true),
      'confirmed': (color: const Color(0xFF4CAF50), btnConfirm: true, btnConfirmText: "Marquer comme terminée", icon: Icons.check_circle, btnCancelled: true),
      'completed': (color: const Color(0xFF2196F3), btnConfirm: false, btnConfirmText: null, icon: null, btnCancelled: false),
      'cancelled': (color: const Color(0xFFF44336), btnConfirm: false, btnConfirmText: null, icon: null, btnCancelled: false),
    };
    final statusManagerData = statusManager[reservationWithUser.base.status] ??
        (color: Colors.grey, btnConfirm: false, btnConfirmText: null, icon: null, btnCancelled: false);
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
                child: simulatedTimeState.when(
                  data: (list){
                    final date = list.first.simulated_time;
                    return Text(
                      DateFormat('EEEE dd/MM/yyyy HH:mm', 'fr_FR').format(date!),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.normal,
                      ),
                    );
                  },
                  loading: () => const Text("...", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  error: (err, stack) => const Text("Erreur", style: TextStyle(fontSize: 10, color: Colors.red)),
                )
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informations client',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person, size: 20),
                          SizedBox(width: 8),
                          Text('Nom: ${reservationWithUser.clientName}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.email, size: 20),
                          SizedBox(width: 8),
                          Text('Email: ${reservationWithUser.clientEmail}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            reservationWithUser.clientPhone ?? 'Téléphone: Non renseigné',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Détails de la réservation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.restaurant, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Le Gourmet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Date: ${DateFormat('EE dd/MM/yyyy', 'fr_FR').format(reservationWithUser.base.datetime)}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Heure: ${DateFormat('HH:mm', 'fr_FR').format(reservationWithUser.base.datetime)}',
                          )],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 20),
                          const SizedBox(width: 8),
                          Text('Nombre de convives: ${reservationWithUser.base.numberOfGuests}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.info, size: 20),
                          const SizedBox(width: 8),
                          const Text('Statut: '),
                          Chip(
                            label:  Text(
                              reservationWithUser.base.status,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: statusManagerData.color,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Demandes spéciales',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reservationWithUser.base.specialRequests ?? 'Aucune demande',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tables assignées',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.table_restaurant, size: 20),
                            const SizedBox(width: 8),
                            const Text('Table 2'),
                            const SizedBox(width: 16),
                            Text(
                              '(4 places)',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.table_restaurant, size: 20),
                          const SizedBox(width: 8),
                          const Text('Table 3'),
                          const SizedBox(width: 16),
                          Text(
                            '(6 places)',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if(statusManagerData.btnConfirm)
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle),
                label: Text(statusManagerData.btnConfirmText ?? ""),
              ),
              const SizedBox(height: 8),
              if(statusManagerData.btnCancelled)
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.cancel),
                label: const Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


