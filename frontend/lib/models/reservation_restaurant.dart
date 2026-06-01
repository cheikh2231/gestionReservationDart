import 'dart:convert';

import 'package:prbd_2526_a04/models/reservation.dart';
import '../core/services/api_client.dart';

class ReservationRestaurant {
  final int id;
  final String name;
  final String address;
  final String city;
  final String phone;

  ReservationRestaurant({required this.id, required this.name, required this.address, required this.city, required this.phone});

  factory ReservationRestaurant.fromJson(Map<String, dynamic> json) {
    return ReservationRestaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      phone: json['phone'],
    );
  }
}