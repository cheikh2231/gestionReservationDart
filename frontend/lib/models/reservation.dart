class Reservation {
  final int id;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantPhone;
  final DateTime dateTime;
  final int nbGuests;
  final String status;
  final String? specialRequests;

  Reservation({
    required this.id,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.restaurantPhone,
    required this.dateTime,
    required this.nbGuests,
    required this.status,
    this.specialRequests,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id:                json['id'],
      restaurantName:    json['restaurant_name'] ?? 'Nom inconnu',
      restaurantAddress: json['restaurant_address'] ?? 'Adresse inconnue',
      restaurantPhone:   json['restaurant_phone'] ?? '',
      dateTime:          DateTime.parse(json['date_time']),
      nbGuests:          json['nb_guests'] ?? 0,
      status:            json['status'] ?? 'pending',
      specialRequests:   json['special_requests'],
    );
  }
}