import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/service.dart';

final restaurantServicesProvider = AsyncNotifierProvider<RestaurantServicesNotifier, List<Service>>(
      () => RestaurantServicesNotifier(),
);
class RestaurantServicesNotifier extends AsyncNotifier<List<Service>> {
  int? _currentRestaurantId;

  @override
  Future<List<Service>> build() async {
    if (_currentRestaurantId == null) return [];
    return await Service.getServicesForRestaurant(
        _currentRestaurantId!);
  }

  Future<void> loadServices(int restaurantId) async {
    _currentRestaurantId = restaurantId;
    state = const AsyncLoading();
    try {
      final services = await Service.getServicesForRestaurant(restaurantId);
      state = AsyncData(services);
    } catch (e, st) {
      state = AsyncError("Erreur lors du chargement des services", st);
    }
  }
}