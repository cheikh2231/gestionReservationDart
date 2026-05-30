class Reservation {
  final int id;
  final int client;
  final int restaurant;
  final DateTime datetime;
  final int numberOfGuests;
  final String status;
  final String? specialRequests;

  Reservation({
    required this.id,
    required this.client,
    required this.restaurant,
    required this.datetime,
    required this.numberOfGuests,
    required this.status,
    this.specialRequests,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      client: json['client'],
      restaurant: json['restaurant'],
      datetime: DateTime.parse(json['datetime']),
      numberOfGuests: json['number_of_guests'] ?? 0,
      status: json['status'] ?? 'pending',
      specialRequests: json['special_requests'],
    );
  }
}