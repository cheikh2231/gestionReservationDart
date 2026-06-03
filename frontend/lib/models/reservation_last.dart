class ReservationLast {
  final int id;
  final DateTime datetime;

  const ReservationLast({
    required this.id,
    required this.datetime,
  });

  factory ReservationLast.fromJson(Map<String, dynamic> json) {
    return ReservationLast(
      id: json['id'],
      datetime: DateTime.parse(json['datetime']),
    );
  }
}