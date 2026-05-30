import 'dart:convert';

import '../core/services/api_client.dart';
import 'restaurant.dart';

class RestaurantReservationsManagement {
  final Restaurant base;
  final DateTime? lastReservation;
  final int nbPendingReservation;

  RestaurantReservationsManagement({
    required this.base,
    this.lastReservation,
    required this.nbPendingReservation,
  });

  factory RestaurantReservationsManagement.fromJson(Map<String, dynamic> json) {
    return RestaurantReservationsManagement(
      base: Restaurant.fromJson(json), // Utilise la factory du modèle de base
      lastReservation: json['last_reservation'] != null
          ? DateTime.parse(json['last_reservation'])
          : null,
      nbPendingReservation: json['nb_pending_reservation']?.toInt() ?? 0,
    );
  }

  static Future<List<RestaurantReservationsManagement>> getMyRestaurantsWithLastReservation() async {
    try {
    final response = await ApiClient.get('get_my_restaurants_with_last_reservation');
    print("DEBUG: Status Code = ${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => RestaurantReservationsManagement.fromJson(item)).toList();
    } else {
      print("DEBUG: ERREUR SERVEUR = ${response.body}");
      throw Exception('Erreur lors du chargement des restaurants');
    }
    } catch (e) {
      // C'EST ICI QU'ON AFFICHE L'ERREUR FLUTTER (si le JSON est mal formé par exemple)
      print("DEBUG: EXCEPTION DANS LE CODE = $e");
      rethrow;
    }
  }
}