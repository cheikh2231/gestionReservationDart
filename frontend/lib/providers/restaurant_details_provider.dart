import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/restaurant.dart';

import '../models/restaurant_full.dart';

final restaurantDetailsProvider = AsyncNotifierProvider<RestaurantDetailsNotifier, RestaurantFull?>(
      () => RestaurantDetailsNotifier(),
);

class RestaurantDetailsNotifier extends AsyncNotifier<RestaurantFull?> {
  int? _currentRestaurantId;

  @override
  Future<RestaurantFull?> build() async {
    return null;
  }

  Future<void> loadRestaurant(int restaurantId) async {
    _currentRestaurantId = restaurantId;

    try {
      final restaurantFull = await RestaurantFull.refreshRestaurantById(restaurantId);

      state = AsyncData(restaurantFull);
    } catch (e, st) {
      state = AsyncError("Erreur lors du rafraîchissement", st);
    }
  }
}