import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/restaurant_reservations_management.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';

final myRestaurantsProvider = AsyncNotifierProvider<MyRestaurantReservationManagementNotifier, List<RestaurantReservationsManagement>>(
      () => MyRestaurantReservationManagementNotifier(),
);

class MyRestaurantReservationManagementNotifier extends AsyncNotifier<List<RestaurantReservationsManagement>> {
  @override
  Future<List<RestaurantReservationsManagement>> build() async {
    ref.watch(securityProvider);
    state = const AsyncLoading();
    try {
      return await RestaurantReservationsManagement.getMyRestaurantsWithLastReservation();
    } catch (e) {
      throw "Impossible de charger les restaurants.\nVeuillez réessayer plus tard.";
    }
  }
}