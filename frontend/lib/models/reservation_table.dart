class ReservationTable {
  final int id;
  final int restaurant;
  final int tableNumber;
  final int capacity;

  ReservationTable({
    required this.id,
    required this.restaurant,
    required this.tableNumber,
    required this.capacity
  });

  factory ReservationTable.fromJson(Map<String, dynamic> json) {
    return ReservationTable(
      id: json['id'],
      restaurant: json['restaurant'],
      tableNumber: json['table_number'],
      capacity: json['capacity'],
    );
  }
}