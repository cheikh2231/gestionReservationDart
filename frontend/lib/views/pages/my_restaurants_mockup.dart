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
        child: restaurantsState.when(
          // [Restaurant] 6. on crée une listview builder pour pouvoir boucler sur notre variable restaurants qu'on récupère depuis restaurantsState
          data: (restaurants) => ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: restaurants.length,
            itemBuilder: (context,index){
              final restaurant = restaurants[index];
              final lastReservation = restaurant.lastReservation != null ? 'Dernière réservation: ${DateFormat('E dd/MM/yyyy', 'fr_FR').format(restaurant.lastReservation!)}' : "";
              final nbPendingReservation = restaurant.nbPendingReservation != null && restaurant.nbPendingReservation! > 0? '${restaurant.nbPendingReservation} demande${restaurant.nbPendingReservation! > 1 ? 's ' : ''}en attente' : "";
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.restaurant, size: 40),
                  title: Text(restaurant.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(restaurant.city),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            restaurant.rating.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '€'* restaurant.priceRange!,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if(lastReservation.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            lastReservation,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (nbPendingReservation.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.pending, size: 14, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            nbPendingReservation,
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
              );
            }
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}


