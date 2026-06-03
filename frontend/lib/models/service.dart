import 'dart:convert';
import 'package:prbd_2526_a04/core/services/api_client.dart';

class Service {
  final int id;
  final int restaurantId;
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  Service({
    required this.id,
    required this.restaurantId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      restaurantId: json['restaurant'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'].toString().substring(0, 5), // si 19:00:00 il coupe au 5 caractere ne le prend pas donc 19:00
      endTime: json['end_time'].toString().substring(0, 5),
    );
  }

  static Future<List<Service>> getServicesForRestaurant(int restaurantId) async {
    final response = await ApiClient.post(
      'get_services',
      body: json.encode({
        'restaurant_id': restaurantId,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Service.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des services');
    }
  }
  //car de base j'ai des chiffres 1 a 7 mais pour avoir les noms je fait cette methode
  String get dayName {
    switch (dayOfWeek) {
      case 1: return 'Lundi';
      case 2: return 'Mardi';
      case 3: return 'Mercredi';
      case 4: return 'Jeudi';
      case 5: return 'Vendredi';
      case 6: return 'Samedi';
      case 7: return 'Dimanche';
      default: return 'Inconnu';
    }
  }
}