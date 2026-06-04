import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../core/widgets/reservations_card.dart';
import '../../models/reservation.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/security_provider.dart';

void main() async {
  await initializeDateFormatting('fr_FR', null);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeClientMockupScreen(),
    ),
  );
}

class HomeClientMockupScreen extends ConsumerStatefulWidget {
  const HomeClientMockupScreen({super.key});

  @override
  ConsumerState<HomeClientMockupScreen> createState() =>
      _HomeClientMockupScreenState();
}

class _HomeClientMockupScreenState
    extends ConsumerState<HomeClientMockupScreen> {
  String _filterReservationString = 'pending';


  List<Reservation> _filteredReservations(List<Reservation> reservations) {
    return _filterReservationString == "all"
        ? reservations
        : reservations
              .where((r) =>( r.status == _filterReservationString ))
              .toList();
  }

  @override
  Widget build(BuildContext context) {
    final reservationsAsync = ref.watch(reservationsProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes réservations'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search_resto');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir les données',
            onPressed: () {
              ref.read(reservationsProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () {
              ref.read(securityProvider.notifier).logout();
              ref.invalidate(reservationsProvider);
              Navigator.pushReplacementNamed(context, '/login');
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
                  'mercredi 04/12/2024 16:00',
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
                    icon: Icon(
                      Icons.check_circle,
                      size: 24,
                      color: Colors.green,
                    ),
                    tooltip: 'Confirmées',
                  ),
                  ButtonSegment(
                    value: 'completed',
                    icon: Icon(
                      Icons.event_available,
                      size: 24,
                      color: Colors.blue,
                    ),
                    tooltip: 'Terminées',
                  ),
                  ButtonSegment(
                    value: 'cancelled',
                    icon: Icon(Icons.cancel, size: 24, color: Colors.red),
                    tooltip: 'Annulées',
                  ),
                ],
                selected: {_filterReservationString},
                onSelectionChanged: (selected) {
                  setState(() {
                    _filterReservationString = selected.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: reservationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Erreur: $e')),
                data: (reservations) => ListView(
                  children: [
                    for (final r in _filteredReservations(reservations))
                      ReservationCard(
                        reservation: r,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/reservation_details',
                          arguments: r.id,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/search_resto');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle réservation'),
      ),
    );
  }

  Widget loading() {
    return Center(child: CircularProgressIndicator(color: Colors.black));
  }
}
