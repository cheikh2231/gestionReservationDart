import 'dart:convert';
import 'package:intl/intl.dart';

import '../core/services/api_client.dart';

class SystemTime{
  final DateTime? simulated_time;
  const SystemTime({
      this.simulated_time,
  });

  factory SystemTime.fromJson(Map<String, dynamic> json) {
    return SystemTime(
      simulated_time: json['simulated_time'] != null
          ? DateTime.parse(json['simulated_time'].toString())
          : null,
    );
  }

  static Future<List<SystemTime>> getSimulatedTime() async {
    final response = await ApiClient.get('get_simulated_time');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => SystemTime.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get word pairs');
    }
  }

  static Future<void> updateSimulatedTime(DateTime? newTime) async {
    final response = await ApiClient.post(
      'update_simulated_time',
      body: json.encode({
        'new_time': newTime != null ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(newTime) : null,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update simulated time');
    }
  }

}
