import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/restaurant.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';

import '../models/restaurant_full.dart';

final myRestaurantsProvider = AsyncNotifierProvider<MyRestaurantReservationManagementNotifier, List<RestaurantFull>>(
      () => MyRestaurantReservationManagementNotifier(),
);

class MyRestaurantReservationManagementNotifier extends AsyncNotifier<List<RestaurantFull>> {
  @override
  Future<List<RestaurantFull>> build() async {
    ref.watch(securityProvider);
    state = const AsyncLoading();
    try {
      return await RestaurantFull.getRestaurants();
    } catch (e) {
      throw "Impossible de charger les restaurants.\nVeuillez réessayer plus tard.";
    }
  }
}