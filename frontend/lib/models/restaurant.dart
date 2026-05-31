

import 'package:prbd_2526_a04/models/restaurant_reservation.dart';

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
  final RestaurantReservation? lastReservation;

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
    this.lastReservation
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
      lastReservation: json['last_reservation'] != null
          ? RestaurantReservation.fromJson(json['last_reservation'])
          : null,
    );
  }
}

