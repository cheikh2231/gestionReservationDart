class Reservation {
  final int id;
  final int client;
  final int restaurant;
  final DateTime datetime;
  final int numberOfGuests;
  final String status;
  final String? specialRequests;

  final String? restaurantName;
  final String? restaurantAddress;
  final String? restaurantCity;
  final String? restaurantPhone;

  Reservation({
    required this.id,
    required this.client,
    required this.restaurant,
    required this.datetime,
    required this.numberOfGuests,
    required this.status,
    this.specialRequests,
    this.restaurantName,
    this.restaurantAddress,
    this.restaurantCity,
    this.restaurantPhone,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id:              json['id'],
      client:          json['client'],
      restaurant:      json['restaurant'],
      datetime:        DateTime.parse(json['datetime']),
      numberOfGuests:  json['number_of_guests'],
      status:          json['status'],
      specialRequests: json['special_requests'],

      restaurantName:    json['restaurant_name'],
      restaurantAddress: json['restaurant_address'],
      restaurantCity:    json['restaurant_city'],
      restaurantPhone:   json['restaurant_phone'],
    );
  }

  Reservation copyWith({
    int? id,
    int? client,
    int? restaurant,
    DateTime? datetime,
    int? numberOfGuests,
    String? status,
    String? specialRequests,
    String? restaurantName,
    String? restaurantAddress,
    String? restaurantCity,
    String? restaurantPhone,
  }) {
    return Reservation(
      id:                id                ?? this.id,
      client:            client            ?? this.client,
      restaurant:        restaurant        ?? this.restaurant,
      datetime:          datetime          ?? this.datetime,
      numberOfGuests:    numberOfGuests    ?? this.numberOfGuests,
      status:            status            ?? this.status,
      specialRequests:   specialRequests   ?? this.specialRequests,
      restaurantName:    restaurantName    ?? this.restaurantName,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      restaurantCity:    restaurantCity    ?? this.restaurantCity,
      restaurantPhone:   restaurantPhone   ?? this.restaurantPhone,
    );
  }
}