import 'package:flutter/material.dart' hide Table;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/providers/reservation_tables.provider.dart';
import 'package:prbd_2526_a04/providers/tables_provider.dart';
import 'package:prbd_2526_a04/views/pages/reservation_details_manager_mockup.dart';

import '../../core/widgets/table_card.dart';
import '../../models/table.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/tables_with_availabilityProvider.dart';

class AssignTablesMockupScreen extends ConsumerStatefulWidget {
  const AssignTablesMockupScreen({super.key, required this.reservationId});

  final reservationId;

  @override
  ConsumerState<AssignTablesMockupScreen> createState() =>
      _ScreenState();
}

class _ScreenState extends ConsumerState<AssignTablesMockupScreen>{
  List<int> selectedTables = [];
  int _nbPlaceTotal=0;
  void _updateCapacity(Table table, bool isSelected) {
    setState(() {
      if (isSelected) {
        _nbPlaceTotal += table.capacity;
        selectedTables.add(table.id);
      } else {
        _nbPlaceTotal -= table.capacity;
        selectedTables.remove(table.id);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final asyncReservations = ref.watch(reservationsProvider);
    final theme = Theme.of(context);
    final simulatedTime = DateTime(2024, 12, 4, 16, 0);

    return asyncReservations.when(
        loading: () =>
        const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text("Erreur : $e"))),
        data: (list) {
          final reservation = list.firstWhere((r) => r.id == widget.reservationId);

          final asyncTables = ref.watch(
              tablesWithAvailabilityProvider((reservation.restaurant.id, widget.reservationId))
          );
          bool placeSuffisante= _nbPlaceTotal >= reservation.numberOfGuests;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReservationDetailsManagerMockupScreen(
                        reservationId: reservation.id,
                      ),
                    ),
                  );
                },
              ),
              title: const Text('Assigner des tables'),
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
                        DateFormat('EEEE dd/MM/yyyy HH:mm', 'fr_FR')
                            .format(simulatedTime),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Réservation',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('${reservation.numberOfGuests} convives'),
                            Text(
                              '${DateFormat('dd/MM/yyyy', 'fr_FR').format(reservation.datetime)} à ${DateFormat('HH:mm', 'fr_FR').format(reservation.datetime)}',
                            )                          ],
                        ),
                      ),
                    ),
                  ),
                  if(_nbPlaceTotal >0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          color: placeSuffisante ?  Colors.green.shade50 : Colors.orange.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  placeSuffisante ? Icons.check_circle : Icons.warning,
                                  color: placeSuffisante ? Colors.green[700] : Colors.orange[700],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Capacité totale: $_nbPlaceTotal place${_nbPlaceTotal != 1 ? 's' : ''}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        placeSuffisante
                                            ? '✓ Capacité suffisante pour ${reservation.numberOfGuests} convive${reservation.numberOfGuests > 1 ? 's' : ''}'
                                            : '⚠️ Capacité insuffisante: $_nbPlaceTotal place${_nbPlaceTotal > 1 ? 's' : ''} pour ${reservation.numberOfGuests} convive${reservation.numberOfGuests > 1 ? 's' : ''}',
                                          style:
                                          TextStyle (
                                            color: placeSuffisante? Colors.green : Colors.orange,
                                         ),
                                      ),
                                      const SizedBox(height: 4),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sélectionnez les tables disponibles',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: asyncTables.when(
                    data: (tables) => ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: tables.length,
                      itemBuilder: (context, index) {
                        final table=tables[index];
                        return TableCard(
                         table:table,
                          onSelected: (Table selectedTable, bool isSelected) {
                            _updateCapacity(selectedTable, isSelected);
                          },
                        );
                      },
                    ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Erreur: $err')),
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedTables.isNotEmpty && placeSuffisante
                            ? () async {
                          final updateRTresult = await ref
                              .read(reservationTablesProvider.notifier)
                              .updateReservationTables(reservation.id, selectedTables);
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Confirmer la réservation'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
    });
  }
}
