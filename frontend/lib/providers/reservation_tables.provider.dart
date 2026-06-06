import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/providers/reservation_provider.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';

import '../models/reservation.dart';
import '../models/reservation_table.dart';

final reservationTablesProvider = AsyncNotifierProvider<ReservationTablesNotifier, List<ReservationTable>>(
      () => ReservationTablesNotifier(),
);

class ReservationTablesNotifier extends AsyncNotifier<List<ReservationTable>> {
  @override
  Future<List<ReservationTable>> build() async {
    // il faut une methode qui récupére tous les reservation table genre ReservationTable.getReservationTables() et on le retourne
    return [];
  }

  Future<void> updateReservationTables(int resid, List<int> tableIds) async {
    state = const AsyncLoading();
    try {
      await ReservationTable.updateReservationTables(resid, tableIds);
      state = const AsyncData([]);
    } catch (e,st) {
      print("${resid} errorTable ${e}");
      print("${tableIds} errorTableST ${st}");
      state = AsyncError("Impossible de mettre à jour les tables réservées.", StackTrace.current);
    }
  }
}