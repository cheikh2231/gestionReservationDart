import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/api_client.dart';
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
    }catch(e,stack){
      print('Erreur: $e');
      print('Stack: $stack');
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _chargeReservations());
  }

  void removeReservation(int id) {
    state.whenData((list) {
      state = AsyncData(list.where((r) => r.id != id).toList());
    });
  }

  void _updateState(Reservation updated) {
    state.whenData((list) {
      state = AsyncData(
        list.map((r) => r.id == updated.id ? updated : r).toList(),
      );
      refresh();
    });
  }

  Future<String?> updateReservation(Reservation updated) async {
    final updateRes = await updated.updateReservation(updated);
    if (updateRes == null) {
      _updateState(updated);
      deleteReservationTables(updated.id);
    }
    return updateRes;
  }

  Future<Reservation?> cancelReservation(int id) async {
    try {
      final resUpdated = await Reservation.cancelReservation(id);
      _updateState(resUpdated);
      return resUpdated;
    } catch (e) {
      return null;
    }
  }

  Future<Reservation?> deleteReservationTables(int id) async {
    try {
      final resUpdated = await Reservation.deleteReservationTables(id);
      _updateState(resUpdated);
      return resUpdated;
    } catch (e) {
      return null;
    }
  }

  Future<Reservation?> completeReservation(int id) async {
    try {
      final resUpdated = await Reservation.completeReservation(id);
      _updateState(resUpdated);
      return resUpdated;
    } catch (e) {
      return null;
    }
  }

  Future<Reservation?> addReservation({
    required int restaurantId,
    required DateTime datetime,
    required int nbGuests,
    String? specialRequest,
  }) async {
    try {
      final newReservation = await Reservation.addReservation(
        restaurantId: restaurantId,
        datetime: datetime,
        nbGuests: nbGuests,
        specialRequest: specialRequest,
      );
      state.whenData((list) {
        state = AsyncData([newReservation, ...list]);
      });
      return newReservation;
    } catch (e) {
      return null;
    }
  }



}