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
}