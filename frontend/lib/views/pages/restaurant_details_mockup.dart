import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/models/restaurant_full.dart';

import 'package:prbd_2526_a04/providers/system_time_provider.dart';
import 'package:prbd_2526_a04/models/restaurant.dart';

import 'package:prbd_2526_a04/providers/restaurant_services_provider.dart';

import '../../providers/restaurant_details_provider.dart';

class RestaurantDetailsMockupScreen extends ConsumerStatefulWidget {
  const RestaurantDetailsMockupScreen({super.key});

  @override
  ConsumerState<RestaurantDetailsMockupScreen> createState() => _RestaurantDetailsMockupScreenState();
}

class _RestaurantDetailsMockupScreenState extends ConsumerState<RestaurantDetailsMockupScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final restaurantFull = ModalRoute.of(context)!.settings.arguments as RestaurantFull;

    Future.microtask(() {
      final notifier = ref.read(restaurantServicesProvider.notifier);
      if (notifier.state.value == null || notifier.state.value!.isEmpty) {
        notifier.loadServices(restaurantFull.restaurant.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final simulatedTimeState = ref.watch(systemTimeProvider);

    final initialRestaurant = ModalRoute.of(context)!.settings.arguments as RestaurantFull;
    final detailsAsync = ref.watch(restaurantDetailsProvider);
    final restaurantFull = detailsAsync.value ?? initialRestaurant;
    final restaurant = restaurantFull.restaurant;
    final servicesAsync = ref.watch(restaurantServicesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Détails du restaurant'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir les données',
            onPressed: () {
              ref.read(restaurantServicesProvider.notifier).loadServices(restaurant.id);
              ref.read(restaurantDetailsProvider.notifier).loadRestaurant(restaurant.id);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${restaurant.address}, ${restaurant.city}', style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(restaurant.phone, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (restaurant.rating != null) ...[
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text('${restaurant.rating} / 5', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                  ],
                  if (restaurant.priceRange != null) ...[
                    Text(
                      'Prix : ${'€' * restaurant.priceRange!}',
                      style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
              const Divider(height: 32),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                restaurant.description ?? "Aucune description disponible pour ce restaurant.",
                style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.4),
              ),
              const Divider(height: 32),

              const Text(
                'Horaires',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              servicesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Erreur : $err', style: const TextStyle(color: Colors.red)),
                data: (services) {
                  if (services.isEmpty) {
                    return const Text(
                      "Aucun horaire défini pour ce restaurant.",
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                    );
                  }

                  // Grouper les services par jour
                  final Map<int, List<dynamic>> groupeServices = {};
                  for (var service in services) {
                    groupeServices.putIfAbsent(service.dayOfWeek, () => []).add(service);
                  }

                  // Séparer en deux colonnes de lundi a jeudi a gauche et de vendredi a dimanche a droite
                  final leftDays = groupeServices.keys.where((k) => k <= 4).toList()..sort();
                  final rightDays = groupeServices.keys.where((k) => k >= 5).toList()..sort();


                  Widget buildDayRow(int dayId) {
                    final dayServices = groupeServices[dayId]!;
                    final dayName = dayServices.first.dayName; // on prend que le nom du service de midi car tout les 2 sont le meme jour

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(dayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          // Heures du jour empilées
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: dayServices.map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text('${s.startTime} - ${s.endTime}'),
                              )).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Affichage sur deux colonnes
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: leftDays.map((d) => buildDayRow(d)).toList(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: rightDays.map((d) => buildDayRow(d)).toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/add_edit_reservation',
                      arguments: {'restaurant': restaurant},
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Réserver une table'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}