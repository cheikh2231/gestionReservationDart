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
    });
  }

  Future<bool> updateReservation(Reservation updated) async {
    final updateRes = await updated.updateReservation(updated);
    if (updateRes) _updateState(updated);
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






}