import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/restaurant.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';

// [Restaurant] 4. Je crée le provider qui va etre appelé et observé depuis la vue, le provider lui va appelé le model

final myRestaurantsProvider = AsyncNotifierProvider<MyRestaurantsNotifier, List<Restaurant>>(
      () => MyRestaurantsNotifier(),
);

class MyRestaurantsNotifier extends AsyncNotifier<List<Restaurant>> {

  @override
  Future<List<Restaurant>> build() async {
    ref.watch(securityProvider);
    state = const AsyncLoading();
    try {
      return await Restaurant.getMyRestaurantsWithLastReservation();
    } catch (e) {
      throw "Impossible de charger les restaurants.\nVeuillez réessayer plus tard.";
    }
  }
}