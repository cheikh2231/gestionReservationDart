import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/table.dart';

final tablesWithAvailabilityProvider = FutureProvider.family<List<Table>, (int, int)>(
      (ref, args) async {
    final (restaurantId, reservationId) = args;
    return await Table.getTablesWithAndWhitoutAvailability(restaurantId, reservationId);
  },
);