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
  static Future<ReservationTable> updateReservationTables(int resid, List<int> tableIds) async {
    final response = await ApiClient.post(
      'confirm_and_assign_tables',
      body: jsonEncode({
        'idres': resid,
        'tables_ids': tableIds,
      }),
    );
    print("${response.body} param : $resid");
    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Erreur inconnue');
    }
    return ReservationTable(
      reservation: resid,
      table: tableIds.first,
    );
  }

}