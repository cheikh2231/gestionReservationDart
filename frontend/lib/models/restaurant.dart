

import 'dart:convert';

import 'package:prbd_2526_a04/models/restaurant_reservation.dart';
import '../core/services/api_client.dart';

class Restaurant {
  final int id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final String? description;
  final double? rating;
  final int? priceRange;
  final int slotDuration;
  final RestaurantReservation? lastReservation;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    this.description,
    this.rating,
    this.priceRange,
    required this.slotDuration,
    this.lastReservation
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      phone: json['phone'],
      description: json['description'],
      rating: json['rating']?.toDouble(),
      priceRange: json['price_range'],
      slotDuration: json['slot_duration'],
      lastReservation: json['last_reservation'] != null
          ? RestaurantReservation.fromJson(json['last_reservation'])
          : null,
    );
  }

  static Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await ApiClient.get('get_restaurants');
      print("DEBUG: Status Code = ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Restaurant.fromJson(item)).toList();
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


  static Future<List<Restaurant>> search(String query, int limit) async {
    final response = await ApiClient.post(
      'get_search_restaurants',
      body: json.encode({
        'search_filter': query.isEmpty ? null : query,
        'limit_count': limit,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Restaurant.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des restaurants');
    }
  }
  static Future<Restaurant> refreshRestaurantById(int id) async {
    final response = await ApiClient.post('get_restaurants');

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);

      final restaurantMap = body.firstWhere(
              (element) => element['id'] == id,
          orElse: () => throw Exception("Restaurant introuvable")
      );

      return Restaurant.fromJson(restaurantMap);
    } else {
      throw Exception("Erreur lors du rafraîchissement");
    }
  }
}

