import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/providers/tables_provider.dart';
import '../models/table.dart';

final tablesWithAvailabilityProvider = FutureProvider.family<List<Table>, (int, int)>(
      (ref, args) async {
    final (restaurantId, reservationId) = args;
    ref.watch(restaurantTablesProvider); // permet de mettre a jours la vue assign table si on modifie quelque chose dans la table "table"
    return await Table.getTablesWithAndWhitoutAvailability(restaurantId, reservationId);
  },
);