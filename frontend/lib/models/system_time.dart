import 'dart:convert';
import '../core/services/api_client.dart';

class SystemTime{
  final DateTime? simulated_time;
  const SystemTime({
      this.simulated_time,
  });

  factory SystemTime.fromJson(Map<String, dynamic> json) {
    return SystemTime(
        simulated_time: DateTime.parse(json['simulated_time'].toString()),
    );
  }

  static Future<List<SystemTime>> getSimulatedTime() async {
    final response = await ApiClient.get('get_simulated_time');
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => SystemTime.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get word pairs');
    }
  }
}
