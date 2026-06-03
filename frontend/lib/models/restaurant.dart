
import 'dart:convert';

import 'package:prbd_2526_a04/models/restaurant_full.dart';

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


    static Future<List<int>> getClosedDays(int id) async {
      final response = await ApiClient.post(
        'get_closed_days',
        body: jsonEncode({'id_res': id}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((r) => r is Map ? r['get_closed_days'] as int : r as int).toList();
      } else {
        print("Erreur: ${response.statusCode} - ${response.body}");
        throw Exception('Erreur lors du chargement des jours fermés');
      }
    }

}

