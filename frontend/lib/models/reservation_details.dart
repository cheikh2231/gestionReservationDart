
import 'package:prbd_2526_a04/models/reservation.dart';


class ReservationDetails {
  final Reservation base;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantPhone;

  ReservationDetails({
    required this.base,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.restaurantPhone
  });

  factory ReservationDetails.fromJson(Map<String, dynamic> json) {
    return ReservationDetails(
      base: Reservation.fromJson(json),
      restaurantName: json['restaurant_name'],
      restaurantAddress: json['restaurant_address'],
      restaurantPhone: json['restaurant_phone'],
    );
  }

}