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

}