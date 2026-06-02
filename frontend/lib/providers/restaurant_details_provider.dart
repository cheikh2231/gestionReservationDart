import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/restaurant.dart';

final restaurantDetailsProvider = AsyncNotifierProvider<RestaurantDetailsNotifier, Restaurant?>(
      () => RestaurantDetailsNotifier(),
);

class RestaurantDetailsNotifier extends AsyncNotifier<Restaurant?> {
  int? _currentRestaurantId;

  @override
  Future<Restaurant?> build() async {
    return null;
  }

  Future<void> loadRestaurant(int restaurantId) async {
    _currentRestaurantId = restaurantId;

    try {
      final restaurant = await Restaurant.refreshRestaurantById(restaurantId);

      state = AsyncData(restaurant);
    } catch (e, st) {
      state = AsyncError("Erreur lors du rafraîchissement", st);
    }
  }
}