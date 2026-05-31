import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prbd_2526_a04/providers/my_restaurants_provider.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/providers/system_time_provider.dart';

import '../../core/widgets/restaurant_card.dart';

class MyRestaurantsMockupScreen extends ConsumerWidget {
  const MyRestaurantsMockupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulatedTimeState = ref.watch(systemTimeProvider);
    final authState = ref.watch(securityProvider);
    final bool estConnecte = authState.value != null;
    final String? userName = ref.read(securityProvider.notifier).loggedName ?? "";
    final theme = Theme.of(context);
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
        child: restaurantsState.when(
          data: (restaurants) => ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: restaurants.length,
            itemBuilder: (context,index){
              final restaurant = restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
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


