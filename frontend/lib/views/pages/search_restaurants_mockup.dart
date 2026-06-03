import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:prbd_2526_a04/core/tools/debounce.dart';
import 'package:prbd_2526_a04/providers/search_restaurants_provider.dart';
import 'package:prbd_2526_a04/providers/system_time_provider.dart';




class SearchRestaurantsMockupScreen extends ConsumerStatefulWidget {
  const SearchRestaurantsMockupScreen({super.key});

  @override
  ConsumerState<SearchRestaurantsMockupScreen> createState() => _SearchRestaurantsMockupScreenState();
}

class _SearchRestaurantsMockupScreenState extends ConsumerState<SearchRestaurantsMockupScreen> {
  late TextEditingController _searchController;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(searchRestaurantsProvider.notifier).currentQuery;
    _searchController = TextEditingController(text: initialQuery);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final asyncRestaurants = ref.watch(searchRestaurantsProvider);
    final simulatedTimeState = ref.watch(systemTimeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Rechercher un restaurant'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir les données',
            onPressed: () => ref.read(searchRestaurantsProvider.notifier).updateSearch(_searchController.text),
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
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Rechercher par nom, ville, description...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _debouncer.call((){
                    ref.read(searchRestaurantsProvider.notifier).updateSearch(value);
                  });
                },
              ),
            ),
            Expanded(
              child: asyncRestaurants.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text(error.toString())),
                  data: (restaurants) {


                    final hasTooManyResults = restaurants.length > maxRestaurantsLimit;
                    final displayList = restaurants.take(maxRestaurantsLimit).toList();

                    if (displayList.isEmpty) {
                      return const Center(child: Text("Aucun restaurant trouvé."));
                    }

                    return Column(
                        children: [
                          if (hasTooManyResults)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              color: Colors.orange.shade50,
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, size: 20, color: Colors.orange.shade800),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Trop de résultats trouvés. Veuillez affiner votre recherche pour voir plus de restaurants.',
                                      style: TextStyle(fontSize: 13, color: Colors.orange.shade900, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: displayList.length,
                              itemBuilder: (context, index) {

                                final restaurantFull = displayList[index];
                                final restaurant = restaurantFull.restaurant;
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8.0),
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

                                            if (restaurant.rating != null) ...[
                                              const SizedBox(width: 12),
                                              const Icon(Icons.star, size: 14, color: Colors.amber),
                                              const SizedBox(width: 2),
                                              Text('${restaurant.rating}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                            ],

                                            if (restaurant.priceRange != null) ...[
                                              const SizedBox(width: 12),
                                              Text('€' * restaurant.priceRange!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                            ],
                                          ],
                                        ),

                                        if (restaurantFull.lastReservation != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Dernière réservation: ${DateFormat('EEE dd/MM/yyyy', 'fr_FR').format(restaurantFull.lastReservation!.datetime)}',
                                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                                ),
                                              ],
                                            ),
                                          ),

                                        if (restaurantFull.nbPending  > 0)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.pending_actions, size: 14, color: Colors.orange),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${restaurantFull.nbPending} demande(s) en attente',
                                                  style: const TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/restaurant_details',
                                        arguments: restaurantFull,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                    );
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.cancel();
    super.dispose();
  }
}
