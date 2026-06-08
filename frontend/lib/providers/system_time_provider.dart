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
    state = const AsyncLoading();
    try {
      return await SystemTime.getSimulatedTime();
    } catch (e) {
      throw "Impossible de charger le temps.\nVeuillez réessayer plus tard.";
    }
  }

  Future<void> updateTime(DateTime? newTime) async {
    state = const AsyncLoading();
    try {
      await SystemTime.updateSimulatedTime(newTime);
      state = AsyncData(await SystemTime.getSimulatedTime());
    } catch (e, st) {
      state = AsyncError("Erreur lors de la mise à jour du temps", st);
    }
  }

}
