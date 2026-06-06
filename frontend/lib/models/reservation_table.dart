import 'dart:convert';
import '../core/services/api_client.dart';

class ReservationTable {
  final int reservation;
  final int table;

  const ReservationTable({
    required this.reservation,
    required this.table,
  });

  factory ReservationTable.fromJson(Map<String, dynamic> json) {
    return ReservationTable(
      reservation: json['reservation'] as int,
      table: json['table'] as int,
    );
  }


}