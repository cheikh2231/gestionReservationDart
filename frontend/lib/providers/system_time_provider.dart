import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbd_2526_a04/models/system_time.dart';
import 'package:prbd_2526_a04/providers/security_provider.dart';

final systemTimeProvider = AsyncNotifierProvider<SystemTimeNotifier, List<SystemTime>>(
      () => SystemTimeNotifier(),
);

class SystemTimeNotifier extends AsyncNotifier<List<SystemTime>>{
  @override
  Future<List<SystemTime>> build() async {
    ref.watch(securityProvider);
    state = const AsyncLoading();
    try {
      return await SystemTime.getSimulatedTime();
    } catch (e) {
      throw "Impossible de charger le temps.\nVeuillez réessayer plus tard.";
    }
  }
}
