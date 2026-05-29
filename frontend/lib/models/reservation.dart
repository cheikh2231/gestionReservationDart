import 'dart:convert';

import '../core/services/api_client.dart';

class Reservation {
  final int id;
  final int client;
  final int restaurant;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantPhone;
  final DateTime dateTime;
  final int nbGuests;
  final String status;
  final String? specialRequests;

  Reservation({
    required this.id,
    required this.client,
    required this.restaurant,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.restaurantPhone,
    required this.dateTime,
    required this.nbGuests,
    required this.status,
    this.specialRequests,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id:                json['id'],
      client:            json['client'],
      restaurant:        json['restaurant'],
      restaurantName:    json['restaurant_name'] ?? 'Nom inconnu',
      restaurantAddress: json['restaurant_address'] ?? 'Adresse inconnue',
      restaurantPhone:   json['restaurant_phone'] ?? '',
      dateTime:          DateTime.parse(json['datetime']),
      nbGuests:          json['number_of_guests'] ?? 0,
      status:            json['status'] ?? 'pending',
      specialRequests:   json['special_requests'],
    );
  }


  static Future<List<Reservation>> getAllReservations() async {
      final response = await ApiClient.post('get_all_reservations');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Reservation.fromJson(item)).toList();
      } else {
        throw Exception('Erreur lors du chargement des reservations pour ce restaurant');
      }

  }

}