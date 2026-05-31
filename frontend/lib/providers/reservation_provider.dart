import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reservation.dart';

final reservationsProvider = AsyncNotifierProvider<ReservationsNotifier, List<Reservation>>(
      () => ReservationsNotifier(),
);


class ReservationsNotifier extends AsyncNotifier<List<Reservation>> {
  @override
  Future<List<Reservation>> build() async {
    return _chargeReservations();
  }

  Future<List<Reservation>> _chargeReservations() async {
    try{
      return await Reservation.getReservations();
    }catch(e){
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _chargeReservations());
  }

  void updateReservation(Reservation updated) {
    state.whenData((list) {
      state = AsyncData(
        list.map((r) => r.id == updated.id ? updated : r).toList(),
      );
    });
  }

  void removeReservation(int id) {
    state.whenData((list) {
      state = AsyncData(list.where((r) => r.id != id).toList());
    });
  }

}