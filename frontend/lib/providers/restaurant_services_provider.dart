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
  void replaceService(Service updatedService) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current
          .map((service) =>
      service.id == updatedService.id ? updatedService : service)
          .toList(),
    );
  }
  Future<void> deleteService(int serviceId) async {
    try {
      // 1. On appelle l'API (qui renvoie void)
      await Service.deleteService(serviceId);

      // 2. Si l'API réussit, on met à jour le state local de Riverpod
      // On récupère la liste actuelle, on filtre pour enlever le service supprimé, et on remet le state
      final currentServices = state.value ?? [];
      state = AsyncData(
        currentServices.where((service) => service.id != serviceId).toList(),
      );

    } catch (e,st) {
      state = AsyncError("Erreur lors de la suppression du service", st);
    }
  }



  Future<Service> updateService(int serviceId, int dayOfWeek, String startTime, String endTime) async {
    final updatedService = await Service.updateService(
      serviceId: serviceId,
      dayOfWeek: dayOfWeek,
      startTime: startTime,
      endTime: endTime,
    );

    final currentServices = state.value ?? [];

    final updatedList = currentServices.map((service) {
      return service.id == serviceId ? updatedService : service;
    }).toList();

    state = AsyncData(updatedList);

    return updatedService;
  }


}