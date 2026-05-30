import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:prbd_2526_a04/models/restaurant.dart';
import 'package:prbd_2526_a04/providers/system_time_provider.dart';

class RestaurantDetailsMockupScreen extends ConsumerWidget {
  const RestaurantDetailsMockupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final simulatedTimeState = ref.watch(systemTimeProvider);

    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;

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
                'Horaires des services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Note technique : Pour le moment, nous affichons une maquette pour les services. en attendant de faire "services_provider", on pourra boucler ici !
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lundi - Vendredi', style: TextStyle(fontWeight: FontWeight.w500)),
                          Text('12:00 - 14:30, 19:00 - 22:30', style: TextStyle(fontFamily: 'monospace')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Samedi - Dimanche', style: TextStyle(fontWeight: FontWeight.w500)),
                          Text('12:00 - 15:00, 19:00 - 23:00', style: TextStyle(fontFamily: 'monospace')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Naviguer vers le formulaire de réservation
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Réserver un table'),
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