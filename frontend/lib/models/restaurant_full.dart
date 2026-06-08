import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/api_client.dart';
import 'reservation_last.dart';
import 'restaurant.dart';

class RestaurantFull {
  final Restaurant restaurant;
  final ReservationLast? lastReservation;
  final int nbPending;

  const RestaurantFull({
    required this.restaurant,
    this.lastReservation,
    required this.nbPending,
  });

  RestaurantFull copyWith({
     Restaurant? restaurant,
     ReservationLast? lastReservation,
     required int nbPending,
  }) {
    return RestaurantFull(
      restaurant: restaurant ?? this.restaurant,
      lastReservation: lastReservation ?? this.lastReservation,
      nbPending: nbPending,
    );
  }



  factory RestaurantFull.fromJson(Map<String, dynamic> json) {
    return RestaurantFull(
      restaurant: Restaurant.fromJson(json['restaurant']),
      lastReservation: json['last_reservation'] != null
          ? ReservationLast.fromJson(json['last_reservation'])
          : null,
      nbPending: json['nb_pending'],
    );
  }

  static Future<List<RestaurantFull>> getRestaurants() async {
    final response = await ApiClient.get(
      'get_restaurants',
    );
    final List<dynamic> list = jsonDecode(response.body);
    return list.map((e) => RestaurantFull.fromJson(e)).toList();
  }

  static Future<List<RestaurantFull>> search(String query, int limit) async {
    final cleanQuery = query.trim();
    final response = await ApiClient.post(
      'get_search_restaurants',
      body: json.encode({
        'search_filter': cleanQuery.isEmpty ? null : cleanQuery,
        'limit_count': limit,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => RestaurantFull.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des restaurants');
    }
  }

  static Future<RestaurantFull> refreshRestaurantById(int id) async {
    final response = await ApiClient.get('get_restaurants');

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);

      final restaurantMap = body.firstWhere(
              (element) => element['id'] == id,
          orElse: () => throw Exception("Restaurant introuvable")
      );

      return RestaurantFull.fromJson(restaurantMap);
    } else {
      throw Exception("Erreur lors du rafraîchissement");
    }
  }

}