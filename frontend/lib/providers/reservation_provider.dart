import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/reservation_restaurant.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';
import '../models/reservation.dart';

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/reservation_restaurant.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';
import '../models/reservation.dart';

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/reservation_restaurant.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';
import '../models/reservation.dart';

final reservationsProvider = AsyncNotifierProvider<ReservationsNotifier, List<Reservation>>(
      () => ReservationsNotifier(),
);


class ReservationsNotifier extends AsyncNotifier<List<Reservation>> {
  @override
  Future<List<Reservation>> build() async {

    ref.watch(securityProvider);
    state = const AsyncLoading();
    try {

      return await Reservation.getReservations();
    } catch (e,stack) {
      throw "Impossible de charger les reservations pour ce restaurant.\nVeuillez réessayer plus tard.";
    }
  }
}