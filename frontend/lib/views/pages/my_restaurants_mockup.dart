import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prbd_2526_a04/providers/my_restaurants_provider.dart';
import 'package:intl/intl.dart';

void main() async {
  await initializeDateFormatting('fr_FR', null);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyRestaurantsMockupScreen(),
    ),
  );
}

class MyRestaurantsMockupScreen extends ConsumerWidget {
  const MyRestaurantsMockupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authState = ref.watch(securityProvider);
    final bool estConnecte = authState.value != null;
    final String? userName = ref.read(securityProvider.notifier).loggedName ?? "";
    final theme = Theme.of(context);
    final simulatedTime = DateTime(2024, 12, 4, 16, 0);
    // [Restaurant] 5. on récupère la liste et l'état du chargement de myrestaurants
    final restaurantsState = ref.watch(myRestaurantsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes restaurants${estConnecte ? " ($userName)" : ""}'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir les données',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion (Benoît P.)',
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
        // [Restaurant] 6. on agit selon l'etat de la liste et si il est okay on boucle sur le resultat
        child: restaurantsState.when(
          data: (restaurants) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: const Icon(Icons.restaurant, size: 40, color: Colors.blue),
                    title: Text(restaurant.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${restaurant.city} • ${restaurant.address}'),
                    trailing: restaurant.rating != null
                        ? Text('⭐ ${restaurant.rating}', style: const TextStyle(fontWeight: FontWeight.bold))
                        : null,
                    onTap: () {
                      // Ici on fera la navigation vers le détail plus tard !
                      print("Clic sur ${restaurant.name}");
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
