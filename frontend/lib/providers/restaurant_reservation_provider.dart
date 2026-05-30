import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';
import '../models/reservation.dart';

// [Restaurant] 4. Je crée le provider qui va etre appelé et observé depuis la vue, le provider lui va appelé le model

final restaurantReservationsProvider = AsyncNotifierProvider<RestaurantReservationsNotifier, List<Reservation>>(
      () => RestaurantReservationsNotifier(),
);


class RestaurantReservationsNotifier extends AsyncNotifier<List<Reservation>> {
  @override
  Future<List<Reservation>> build() async {
    ref.watch(securityProvider);
    state = const AsyncLoading();
    try {
      return await Reservation.getAllReservations();
    } catch (e) {
      throw "Impossible de charger les reservations pour ce restaurant.\nVeuillez réessayer plus tard.";
    }
  }
}