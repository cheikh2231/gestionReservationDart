class LastReservation {
  final int id;
  final DateTime datetime;

  const LastReservation({
    required this.id,
    required this.datetime,
  });

  factory LastReservation.fromJson(Map<String, dynamic> json) {
    return LastReservation(
      id: json['id'],
      datetime: DateTime.parse(json['datetime']),
    );
  }
}