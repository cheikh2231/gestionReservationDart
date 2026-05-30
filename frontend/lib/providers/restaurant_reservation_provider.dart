import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/reservation_with_user.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';
import '../models/reservation.dart';

final restaurantReservationsProvider = AsyncNotifierProvider<RestaurantReservationsNotifier, List<ReservationWithUser>>(
      () => RestaurantReservationsNotifier(),
);


class RestaurantReservationsNotifier extends AsyncNotifier<List<ReservationWithUser>> {
  @override
  Future<List<ReservationWithUser>> build() async {

    ref.watch(securityProvider);
    state = const AsyncLoading();
    try {

      return await ReservationWithUser.getReservationWithUserName();
    } catch (e,stack) {
      throw "Impossible de charger les reservations pour ce restaurant.\nVeuillez réessayer plus tard.";
    }
  }
}