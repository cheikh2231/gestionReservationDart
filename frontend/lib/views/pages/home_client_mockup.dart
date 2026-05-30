import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../core/services/api_client.dart';

import '../../core/widgets/reservations_card.dart';
import '../../models/reservation.dart';
import '../../models/reservation_details.dart';
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
  ConsumerState<HomeClientMockupScreen> createState() => _HomeClientMockupScreenState();
}

class _HomeClientMockupScreenState extends ConsumerState<HomeClientMockupScreen> {
  List<ReservationDetails> _reservations = [];
  bool _loading = true;
  String _filterReservationString = 'pending';

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {

    final response = await ApiClient.get('get_reservations');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _reservations = data.map((json) => ReservationDetails.fromJson(json)).toList();
        _loading = false;
      });
    }
  }

  List<ReservationDetails> _filteredReservations(){
    return _filterReservationString == "all" ? _reservations : _reservations.where((r)=>r.base.status == _filterReservationString).toList();
 }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes réservations'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir les données',
            onPressed: () { _loadReservations(); },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
              ref.read(securityProvider.notifier).logout();
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
                message: 'Date/heure simulée utilisée pour les tests.\nCliquez pour modifier.',
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
                        Icons.check_circle, size: 24, color: Colors.green),
                    tooltip: 'Confirmées',
                  ),
                  ButtonSegment(
                    value: 'completed',
                    icon: Icon(
                        Icons.event_available, size: 24, color: Colors.blue),
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
              child: _loading
                  ? loading()
                  : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  for (final r in _filteredReservations())
                    ReservationCard(
                      reservationDetails: r,
                      onTap: () =>
                          Navigator.pushNamed(
                            context,
                            '/reservation_details',
                            arguments: r,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () { Navigator.pushNamed(context, '/search_resto');},
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle réservation'),
      ),
    );
  }
  Widget loading() {
    return Center(child: CircularProgressIndicator(color: Colors.black));
  }
}