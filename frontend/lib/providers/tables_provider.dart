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
}

final restaurantTablesProvider = AsyncNotifierProvider<RestaurantTablesNotifier, List<Table>>(
      () => RestaurantTablesNotifier(),
);

class RestaurantTablesNotifier extends AsyncNotifier<List<Table>> {
  int? _currentRestaurantId;

  @override
  Future<List<Table>> build() async {
    if (_currentRestaurantId == null) return [];
    return await Table.getTablesByRestaurant(_currentRestaurantId!);
  }

  Future<void> loadTables(int restaurantId) async {
    _currentRestaurantId = restaurantId;
    state = const AsyncLoading();
    try {
      final tables = await Table.getTablesByRestaurant(restaurantId);
      state = AsyncData(tables);
    } catch (e, st) {
      state = AsyncError("Erreur lors du chargement des tables du restaurant", st);
    }
  }

  Future<void> saveTable({
    required int tableNumber,
    required int capacity,
    int? tableId,
  }) async {
    if (_currentRestaurantId == null) return;

    state = const AsyncLoading();
    try {
      await Table.saveTable(
        restaurantId: _currentRestaurantId!,
        tableNumber: tableNumber,
        capacity: capacity,
        tableId: tableId,
      );

      await loadTables(_currentRestaurantId!);
    } catch (e, st) {
      state = AsyncError("Erreur lors de la sauvegarde de la table", st);
      rethrow;
    }
  }
}