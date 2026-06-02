import 'dart:convert';
import 'package:prbd_2526_a04/models/reservation_client.dart';
import 'package:prbd_2526_a04/models/reservation_restaurant.dart';
import 'package:prbd_2526_a04/models/reservation_table.dart';
import '../core/services/api_client.dart';

class Reservation {
  final int id;
  final ReservationClient client;
  final ReservationRestaurant restaurant;
  final DateTime datetime;
  final int numberOfGuests;
  final String status;
  final String? specialRequests;
  final List<ReservationTable> tables;

  Reservation({
    required this.id,
    required this.client,
    required this.restaurant,
    required this.datetime,
    required this.numberOfGuests,
    required this.status,
    this.specialRequests,
    required this.tables,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    id: json['id'],
    client: ReservationClient.fromJson(json['client']),
    restaurant: ReservationRestaurant.fromJson(json['restaurant']),
    datetime: DateTime.parse(json['datetime']),
    numberOfGuests: json['number_of_guests'],
    status: json['status'],
    specialRequests: json['special_requests'],
    tables: (json['tables'] as List).map((i) => ReservationTable.fromJson(i)).toList(),
  );

  static Future<List<Reservation>> getReservations() async {
    final response = await ApiClient.get('get_reservations');

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Reservation.fromJson(item)).toList();
    } else {
      print('ERREUR SERVEUR : ${response.statusCode}');
      print('MESSAGE SERVEUR : ${response.body}');

      throw Exception('Failed to get reservations');
    }
  }

  static Future<Reservation> cancelReservation(int id) async{
      final response = await ApiClient.post(
        'cancel_reservation',
        body: jsonEncode({'id_res': id}),
      );
      return Reservation.fromJson(jsonDecode(response.body));
  }

  static Future<Reservation> deleteReservationTables(int id) async{
    final response = await ApiClient.post(
      'delete_reservation_tables',
      body: jsonEncode({'id_res': id}),
    );
    // print( "${response.body} erreur dans le model et le param : ${id}  ");
    return Reservation.fromJson(jsonDecode(response.body));
  }

  static Future<Reservation> completeReservation(int id) async{
    final response = await ApiClient.post(
      'complete_reservation',
      body: jsonEncode({'id_res': id}),
    );
    // print( "${response.body} erreur dans le model et le param : ${id}  ");
    return Reservation.fromJson(jsonDecode(response.body));
  }
}