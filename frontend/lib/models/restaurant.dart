import 'dart:convert';

import '../core/services/api_client.dart';

class Restaurant {
  // [Restaurant] 1. Je crée le model avec les attributs de restaurant et un constructeur
  final int id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final String? description;
  final double? rating;
  final int? priceRange;
  final int slotDuration;

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
  });
 // [Restaurant] 2. Je crée une factory pour pouvoir récuperer les réstaurants au format Json , elles reçues au format json depuis postgrest
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
    );
  }

  // [Restaurant] 3. Je crée la requete 'get_my_restaurants' pour demander la liste au serveur
  static Future<List<Restaurant>> getMyRestaurants() async {
    final response = await ApiClient.post('get_my_restaurants');

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Restaurant.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des restaurants');
    }
  }
}