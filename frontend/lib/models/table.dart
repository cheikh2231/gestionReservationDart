import 'dart:convert';

import 'package:prbd_2526_a04/models/restaurant.dart';

import '../core/services/api_client.dart';

class Table {
  final int id;
  final Restaurant restaurant;
  final int tableNumber;
  final int capacity;
  final bool? reserved;
  Table({
    required this.id,
    required this.restaurant,
    required this.tableNumber,
    required this.capacity,
    this.reserved
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      restaurant: Restaurant.fromJson(json['restaurant']),
      tableNumber: json['table_number'],
      capacity: json['capacity'],
      reserved: json['reserved'] ?? null,
    );
  }

  static Future<List<Table>> getTables() async {
    final response = await ApiClient.get('get_tables');

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Table.fromJson(item)).toList();
    } else {
      // print('ERREUR SERVEUR : ${response.statusCode}');
      // print('MESSAGE SERVEUR : ${response.body}');
      throw Exception('Failed to get tables');
    }
  }

  static Future<List<Table>> getTablesWithAndWhitoutAvailability($restaurant_id, $reservation_id)  async {
    final response = await ApiClient.get('get_tables_with_and_whitout_availability');

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Table.fromJson(item)).toList();
    } else {
      // print('ERREUR SERVEUR : ${response.statusCode}');
      // print('MESSAGE SERVEUR : ${response.body}');
      throw Exception('Failed to get tables');
    }
  }

  static Future<List<Table>> getTablesByRestaurant(int restaurantId) async {
    final response = await ApiClient.post(
      'get_restaurant_tables',
      body: json.encode({'p_restaurant_id': restaurantId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Table.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des tables du restaurant');
    }
  }

  static Future<Table> saveTable({
    required int restaurantId,
    required int tableNumber,
    required int capacity,
    int? tableId,
  }) async {
    final response = await ApiClient.post(
      'save_table',
      body: json.encode({
        'p_restaurant_id': restaurantId,
        'p_table_number': tableNumber,
        'p_capacity': capacity,
        'p_table_id': tableId,
      }),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Table.fromJson(jsonBody);
    } else {
      throw Exception('Erreur lors de la sauvegarde de la table');
    }
  }

}