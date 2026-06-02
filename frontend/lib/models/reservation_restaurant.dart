class ReservationRestaurant {
  final int id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final String? description;
  final double? rating;
  final int? priceRange;
  final int slotDuration;

  ReservationRestaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    this.description,
    this.rating,
    this.priceRange,
    required this.slotDuration,
  });

  factory ReservationRestaurant.fromJson(Map<String, dynamic> json) {
    return ReservationRestaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      phone: json['phone'],
      description: json['description'],
      rating: json['rating']?.toDouble(),
      priceRange: json['price_range'],
      slotDuration: json['slot_duration'],
    );
  }
}