import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/restaurant.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';

final myRestaurantsProvider = AsyncNotifierProvider<MyRestaurantReservationManagementNotifier, List<Restaurant>>(
      () => MyRestaurantReservationManagementNotifier(),
);

class MyRestaurantReservationManagementNotifier extends AsyncNotifier<List<Restaurant>> {
  @override
  Future<List<Restaurant>> build() async {
    ref.watch(securityProvider);
    state = const AsyncLoading();
    try {
      return await Restaurant.getRestaurants();
    } catch (e) {
      throw "Impossible de charger les restaurants.\nVeuillez réessayer plus tard.";
    }
  }
}