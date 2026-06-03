
import 'dart:convert';

import 'package:intl/intl.dart';
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
    Future<List<String>> getSlots(DateTime date, DateTime simulatedTime) async {
      final response = await ApiClient.post(
        'get_slots',
        body: jsonEncode({
          'restaurant_id': id,
          'simulated_time': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(simulatedTime),
          'target_date': DateFormat('yyyy-MM-dd').format(date),
        }),
      );

      // Sécurité : On vérifie si la réponse est déjà une liste ou une chaîne brute
      final dynamic decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map((e) => (e['slot_time'] as String).substring(0, 5)).toList();
      } else if (decoded is Map && decoded.containsKey('data')) {
        // Si l'API enveloppe la liste dans un objet contenant une clé 'data'
        final List<dynamic> list = decoded['data'];
        return list.map((e) => (e['slot_time'] as String).substring(0, 5)).toList();
      } else {
        throw TypeError();
      }
    }

    Future<bool> noTableDispo(DateTime date, String slot, int nbGuests, int? excludedReservationId) async {
      // On déclare les clés dans le STRICT ordre des arguments de la fonction SQL
      final Map<String, dynamic> bodyParams = {
        'date': DateFormat('yyyy-MM-dd').format(date),
        'nb_guests': nbGuests,
        'restaurant_id': id,
        'slot': slot,
        'excluded_reservation_id': excludedReservationId, // Mis à la fin comme en SQL !
      };

      final response = await ApiClient.post(
        'no_table_dispo',
        body: jsonEncode(bodyParams),
      );

      final dynamic decoded = response.body is String
          ? jsonDecode(response.body)
          : response.body;

      // Sécurité pour intercepter la réponse booléenne de PostgREST
      if (decoded is List && decoded.isNotEmpty) {
        final firstElement = decoded.first;
        if (firstElement is Map) {
          return firstElement['no_table_dispo'] as bool? ?? false;
        }
        return firstElement as bool;
      }

      if (decoded is Map) {
        if (decoded.containsKey('no_table_dispo')) {
          return decoded['no_table_dispo'] as bool;
        }
        // Si PostgREST renvoie une erreur encapsulée
        if (decoded.containsKey('message')) {
          print("Erreur PostgREST: ${decoded['message']}");
          return true; // Par sécurité, on bloque si l'API crash
        }
      }

      if (decoded is bool) {
        return decoded;
      }

      return false;
    }

}

