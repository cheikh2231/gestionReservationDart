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
  final DateTime? lastReservation; // [Restaurant] 7. on ajout un 10 param pour la derniere reservation, il faut crée un nouveau type 'restaurant_with_last_reservation' dans notre fichier sql pour dire a postgreSQL que notre fonction retourne désormais 10 colonnes et non plus 9
  final int? nbPendingReservation;
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
    this.lastReservation,
    this.nbPendingReservation,
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
      lastReservation: json['last_reservation'] != null
          ? DateTime.parse(json['last_reservation'])
          : null,
      nbPendingReservation: json['nb_pending_reservation']?.toInt(),
    );
  }

  // [Restaurant] 3. Je crée la requete 'get_my_restaurants_with_last_reservation' pour demander la liste au serveur
  static Future<List<Restaurant>> getMyRestaurantsWithLastReservation() async {
    try {
    final response = await ApiClient.get('get_my_restaurants_with_last_reservation');
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
}