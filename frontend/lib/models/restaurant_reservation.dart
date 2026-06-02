class RestaurantReservation {
  final int id;
  final int client;
  final int restaurant;
  final DateTime datetime;
  final int numberOfGuests;
  final String status;
  final String? specialRequests;
  final int? countPending;

  RestaurantReservation({ required this.id,
  required this.client,
  required this.restaurant,
  required this.datetime,
  required this.numberOfGuests,
  required this.status,
  this.specialRequests,
  this.countPending,
  });
  factory RestaurantReservation.fromJson(Map<String, dynamic> json) {
    return RestaurantReservation(
      id: json['id'],
      client: json['client'],
      restaurant: json['restaurant'],
      datetime: DateTime.parse(json['datetime']),
      numberOfGuests: json['number_of_guests'],
      status: json['status'],
      specialRequests: json['special_requests'],
      countPending: json['nb_pending_reservation']?.toInt(),
    );
  }
}