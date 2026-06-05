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
      reservation:  json['reservation'],
      table: json['table'],
    );
  }

  static Future<ReservationTable> updateReservationTables(int resid, List<int> tableIds) async{
    final response = await ApiClient.post(
      'confirm_and_assign_tables',
      body: jsonEncode({
        'idres': resid,
        'tables_ids':tableIds,
      }),
    );
    print( "${response.body} erreur dans le model et le param : ${resid}  ");
    return ReservationTable.fromJson(jsonDecode(response.body));
  }

}