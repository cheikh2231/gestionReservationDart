import 'dart:convert';

import 'package:prbd_2526_a04/models/reservation.dart';
import '../core/services/api_client.dart';

class ReservationWithUser {
  final Reservation base;
  final String? clientName;

  ReservationWithUser({
    required this.base,
    required this.clientName,
  });

  factory ReservationWithUser.fromJson(Map<String, dynamic> json) {
    return ReservationWithUser(
      base: Reservation.fromJson(json),
      clientName: json['full_name'],
    );
  }

  static Future<List<ReservationWithUser>> getReservationWithUserName() async {
    try {
      final response = await ApiClient.get('get_all_reservations_with_user');
      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => ReservationWithUser.fromJson(item)).toList();
      } else {
        print("DEBUG: ERREUR API = ${response.statusCode}");
        print("DEBUG: MESSAGE ERREUR = ${response.body}");
        throw Exception('Erreur lors du chargement des reservationss');
      }
    } catch (e) {
      rethrow;
    }
  }

}