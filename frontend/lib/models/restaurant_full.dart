import 'dart:convert';

import '../core/services/api_client.dart';
import 'last_reservation.dart';
import 'restaurant.dart';

class RestaurantFull {
  final Restaurant restaurant;
  final LastReservation? lastReservation;
  final int nbPending;

  const RestaurantFull({
    required this.restaurant,
    this.lastReservation,
    required this.nbPending,
  });

  factory RestaurantFull.fromJson(Map<String, dynamic> json) {
    return RestaurantFull(
      restaurant: Restaurant.fromJson(json['restaurant']),
      lastReservation: json['last_reservation'] != null
          ? LastReservation.fromJson(json['last_reservation'])
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
    final response = await ApiClient.post(
      'get_search_restaurants',
      body: json.encode({
        'search_filter': query.isEmpty ? null : query,
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