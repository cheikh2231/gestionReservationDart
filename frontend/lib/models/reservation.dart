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

  static Future<List<Reservation>> getAllReservations() async {
      final response = await ApiClient.get('get_all_reservations');
      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Reservation.fromJson(item)).toList();
      } else {
        throw Exception('Erreur lors du chargement des reservations pour ce restaurant');
      }

  }

}