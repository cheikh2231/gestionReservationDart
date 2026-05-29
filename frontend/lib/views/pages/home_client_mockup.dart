import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../core/services/api_client.dart';

import '../../core/tools/params.dart';
import '../../core/widgets/reservations_card.dart';
import '../../models/reservation.dart';

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

class HomeClientMockupScreen extends StatefulWidget {

  const HomeClientMockupScreen({super.key});

  @override
  State<HomeClientMockupScreen> createState() => _HomeClientMockupScreenState();
}

class _HomeClientMockupScreenState extends State<HomeClientMockupScreen> {
  List<Reservation> _reservations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Params.setValue('token', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiY2xpZW50Iiwic3ViIjoiYnJsYWNyb2l4QGVwZmMuZXUiLCJuYW1lIjoiQnJ1bm8iLCJ1c2VyX2lkIjo2LCJleHAiOjE3Nzk5ODQ5NTN9.G6tV2pqfb9G8cQ22tKKgnXJ2WS1d63XOvrV7d0EujLE'); // le token de bruno en dur pour test
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final response = await ApiClient.get('get_reservations');
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.statusCode == 200) {
      print('ok');
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        print('$json');
        _reservations = data.map((json) => Reservation.fromJson(json)).toList();
        _loading = false;
      });
    }
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
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
                selected: const {'pending'},
                onSelectionChanged: (_) {},
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  for (final r in _reservations)
                    ReservationCard(
                      reservation: r,
                      onTap: () =>
                          Navigator.pushNamed(
                            context,
                            '/reservation_details',
                            arguments: r,
                          ),
                    ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.restaurant, size: 40),
                        title: const Text('La Trattoria'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                const Text('Bruxelles'),
                                const SizedBox(width: 12),
                                const Icon(Icons.star,
                                    size: 14, color: Colors.amber),
                                const SizedBox(width: 2),
                                Text(
                                  '4.2',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '€€',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  'Dernière réservation: jeu. 28/11/2024',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.pending,
                                    size: 14, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  '1 demande en attente',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
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
}