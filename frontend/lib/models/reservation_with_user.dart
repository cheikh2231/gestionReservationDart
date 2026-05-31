import 'dart:convert';

import 'package:prbd_2526_a04/models/reservation.dart';
import '../core/services/api_client.dart';

class ReservationWithUser {
  final Reservation base;
  final String? clientName;
  final String? clientEmail;
  final String? clientPhone;

  ReservationWithUser({
    required this.base,
    this.clientName,
    this.clientEmail,
    this.clientPhone,
  });

  factory ReservationWithUser.fromJson(Map<String, dynamic> json) {
    return ReservationWithUser(
      base: Reservation.fromJson(json),
      clientName: json['full_name'],
      clientEmail: json['email'],
      clientPhone: json['phone'],
    );
  }

  static Future<List<ReservationWithUser>> getReservationWithUserName() async {
    try {
      final response = await ApiClient.get('get_all_reservations_with_user');
      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => ReservationWithUser.fromJson(item)).toList();
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception('Erreur lors du chargement des reservationss');
      }
    } catch (e) {
      rethrow;
    }
  }

}