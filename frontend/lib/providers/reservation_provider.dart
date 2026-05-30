import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/core/services/api_client.dart';
import 'package:prbd_2526_a04/models/reservation.dart';

import '../models/reservation_details.dart';

final reservationsProvider = AsyncNotifierProvider<ReservationsNotifier, List<ReservationDetails>>(
      () => ReservationsNotifier(),
);

class ReservationsNotifier extends AsyncNotifier<List<ReservationDetails>> {
  @override
  Future<List<ReservationDetails>> build() async {
    return _chargeReservations();
  }

  Future<List<ReservationDetails>> _chargeReservations() async {
    final response = await ApiClient.get('get_reservations');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ReservationDetails.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _chargeReservations());
  }

  void updateReservation(ReservationDetails updated) {
    state.whenData((list) {
      state = AsyncData(
        list.map((r) => r.base.id == updated.base.id ? updated : r).toList(),
      );
    });
  }

  void removeReservation(int id) {
    state.whenData((list) {
      state = AsyncData(list.where((r) => r.base.id != id).toList());
    });
  }
}