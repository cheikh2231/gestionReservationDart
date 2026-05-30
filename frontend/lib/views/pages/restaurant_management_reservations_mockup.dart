import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/models/reservation.dart';
import 'package:prbd_2526_a04/providers/restaurant_reservation_provider.dart';

import '../../core/widgets/restaurant_reservation_card.dart';
import '../../models/restaurant.dart';
import '../../providers/system_time_provider.dart';

class RestaurantManagementReservationsMockupScreen extends ConsumerStatefulWidget {
  const RestaurantManagementReservationsMockupScreen(
      {super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  ConsumerState<RestaurantManagementReservationsMockupScreen> createState() =>
      _ScreenState();
}

class _ScreenState extends ConsumerState<RestaurantManagementReservationsMockupScreen> {
  String selectedStatus = 'all';
  List<Reservation> filterReservation(List<Reservation> listReservation) {
    if(selectedStatus=='all') {
      return listReservation;
    }
    listReservation = listReservation.where((r) => r.status == selectedStatus).toList();
    return listReservation;
  }
  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    final theme = Theme.of(context);
    final simulatedTimeState = ref.watch(systemTimeProvider);
    final reservationState = ref.watch(restaurantReservationsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/myrestaurants');
          },
        ),
        title: Text(restaurant.name),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: SegmentedButton<String>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: 'all',
                    icon: Icon(Icons.list, size: 24),
                    tooltip: 'Toutes',
                  ),
                  ButtonSegment(
                    value: 'pending',
                    icon: Icon(Icons.pending, size: 24, color: Colors.orange),
                    tooltip: 'En attente',
                  ),
                  ButtonSegment(
                    value: 'confirmed',
                    icon: Icon(Icons.check_circle, size: 24, color: Colors.green),
                    tooltip: 'Confirmées',
                  ),
                  ButtonSegment(
                    value: 'completed',
                    icon: Icon(Icons.event_available, size: 24, color: Colors.blue),
                    tooltip: 'Terminées',
                  ),
                  ButtonSegment(
                    value: 'cancelled',
                    icon: Icon(Icons.cancel, size: 24, color: Colors.red),
                    tooltip: 'Annulées',
                  ),
                ],
                selected: {selectedStatus},
                onSelectionChanged: (newSelection) {
                  setState(() => selectedStatus = newSelection.first);
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: reservationState.when(
                data: (reservations) {
                   final filteredList = filterReservation(reservations);
                   return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredList.length,
                    itemBuilder: (context,index){
                      return RestaurantReservationCard(
                        reservation: filteredList[index],
                        status: selectedStatus,
                      );
                    },
                   );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text(error.toString())),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_restaurant),
            label: 'Tables',
          ),
        ],
      ),
    );
  }


}
