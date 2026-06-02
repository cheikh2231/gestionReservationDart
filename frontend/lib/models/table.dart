import 'dart:convert';

import 'package:prbd_2526_a04/models/reservation.dart';
import 'package:prbd_2526_a04/models/table_restaurant.dart';

import '../core/services/api_client.dart';

class Table {
  final int id;
  final TableRestaurant restaurant;
  final int table_number;
  final int capacity;

  Table({
    required this.id,
    required this.restaurant,
    required this.table_number,
    required this.capacity,
  });

  factory Table.fromJson(Map<String, dynamic> json) => Table(
    id: json['id'],
    restaurant: TableRestaurant.fromJson(json['restaurant']),
    table_number: json['table_number'],
    capacity: json['capacity'],
  );


  static Future<List<Table>> getTables() async {
    final response = await ApiClient.get('get_tables');
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Table.fromJson(item)).toList();
    } else {
      print('ERREUR SERVEUR : ${response.statusCode}');
      print('MESSAGE SERVEUR : ${response.body}');

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