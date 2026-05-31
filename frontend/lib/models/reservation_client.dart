class ReservationClient {
  final int id;
  final String fullName;
  final String email;
  final String phone;

  ReservationClient({required this.id, required this.fullName, required this.email, required this.phone});

  factory ReservationClient.fromJson(Map<String, dynamic> json) {
    return ReservationClient(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}