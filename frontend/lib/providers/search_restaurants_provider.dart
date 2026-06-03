import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/restaurant.dart';

import '../models/restaurant_full.dart';

// Parametre configurable (Limite de la recherche)
const int maxRestaurantsLimit = 5;

final searchRestaurantsProvider = AsyncNotifierProvider<SearchRestaurantsNotifier, List<RestaurantFull>>(
      () => SearchRestaurantsNotifier(),
);

class SearchRestaurantsNotifier extends AsyncNotifier<List<RestaurantFull>> {
  // requete de saisi de base
  String currentQuery = '';

  @override
  Future<List<RestaurantFull>> build() async {
    return await _fetchData(currentQuery);
  }

  Future<void> updateSearch(String query) async {
    currentQuery = query;
    state = const AsyncLoading();
    try {
      final restaurants = await _fetchData(query);
      state = AsyncData(restaurants);
    } catch (e, st) {
      state = AsyncError("Erreur lors de la recherche", st);
    }
  }

  Future<List<RestaurantFull>> _fetchData(String query) async {
    // limite + 1 pour le message d'erreur
    final limitForServer = maxRestaurantsLimit + 1;

    return await RestaurantFull.search(query, limitForServer);
  }

}