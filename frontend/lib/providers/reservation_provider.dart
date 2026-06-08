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
      final updatedList = list.map((r) => r.id == updated.id ? updated : r).toList();
      updatedList.sort((a, b) {
        final dateCompare = b.datetime.compareTo(a.datetime);
        return dateCompare != 0 ? dateCompare :
         b.id.compareTo(a.id);
      });
      state = AsyncData(updatedList);
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
      _updateState(newReservation);
      return newReservation;
    } catch (e) {
      return null;
    }
  }


  Future<Reservation?> confirmAndAssignTables(int resid, List<int> tableIds) async {
    try {
      final result=await Reservation.confirmAndAssignTables(resid, tableIds);
      _updateState(result);
      // ref.watch(myRestaurantsProvider)._updateState()
      return result;

    } catch (e,st) {
      print("${resid} errorTable ${e}");
      print("${tableIds} errorTableST ${st}");
      state = AsyncError("Impossible de mettre à jour les tables réservées.", StackTrace.current);
    }
    return null;
  }




}