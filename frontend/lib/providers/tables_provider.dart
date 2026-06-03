import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';
import '../models/table.dart';

final tablesProvider = AsyncNotifierProvider<TablesNotifier, List<Table>>(
      () => TablesNotifier(),
);


class TablesNotifier extends AsyncNotifier<List<Table>> {
  @override
  Future<List<Table>> build() async {
    ref.watch(securityProvider);
    state = const AsyncLoading();
    try {
      return await Table.getTables();
    } catch (e) {
      throw "Impossible de charger les tables.\nVeuillez réessayer plus tard.";
    }
  }


  Future<void> getTablesWithAndWhitoutAvailability(int restaurantId, int reservationId) async {
    state = const AsyncLoading();
    try {
      final tables = await Table.getTablesWithAndWhitoutAvailability(restaurantId,reservationId);
      state = AsyncData(tables);
    } catch (e, st) {
      state = AsyncError("Erreur lors du chargement des tables disponibles", st);
    }
  }
}