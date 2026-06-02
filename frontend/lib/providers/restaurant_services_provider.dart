import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/restaurant_service.dart';

final restaurantServicesProvider = AsyncNotifierProvider<RestaurantServicesNotifier, List<RestaurantService>>(
      () => RestaurantServicesNotifier(),
);
class RestaurantServicesNotifier extends AsyncNotifier<List<RestaurantService>> {
  int? _currentRestaurantId;

  @override
  Future<List<RestaurantService>> build() async {
    if (_currentRestaurantId == null) return [];
    return await RestaurantService.getServicesForRestaurant(
        _currentRestaurantId!);
  }

  Future<void> loadServices(int restaurantId) async {
    _currentRestaurantId = restaurantId;
    state = const AsyncLoading();
    try {
      final services = await RestaurantService.getServicesForRestaurant(restaurantId);
      state = AsyncData(services);
    } catch (e, st) {
      state = AsyncError("Erreur lors du chargement des services", st);
    }
  }
}