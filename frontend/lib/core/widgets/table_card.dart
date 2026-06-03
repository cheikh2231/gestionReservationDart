import 'package:flutter/material.dart' hide Table;
import 'package:prbd_2526_a04/models/table.dart';

class TableCard extends StatelessWidget {
  const TableCard({
    super.key,
    required this.table,
  });
  final Table table;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: true,
        onChanged: (_) {},
        title: Text('Table ${table.tableNumber}'),
        subtitle: Text(
          'Capacité: ${table.capacity} personnes',
        ),
        secondary: const Icon(Icons.table_restaurant),
      ),
    );
  }
}