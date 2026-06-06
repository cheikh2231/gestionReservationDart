import 'package:flutter/material.dart' hide Table;
import 'package:prbd_2526_a04/models/table.dart';

class TableCard extends StatefulWidget {
  final Table table;
  final Function(Table,bool) onSelected;
  const TableCard({
    super.key,
    required this.table,
    required this.onSelected,
  });
  @override
  State<TableCard> createState() => _TableCardState();
}
class _TableCardState extends State<TableCard>{
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final capacityText = widget.table.reserved! ? "Occupée pour ce service" : 'Capacité: ${widget.table.capacity} personnes' ;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        enabled:!(widget.table.reserved ?? false),
        value: isChecked,
        onChanged: (bool? newValue) {
          setState(() {
            isChecked = newValue ?? false;
            widget.onSelected(widget.table,isChecked);
          });
        },
        title: Text(
            'Table ${widget.table.tableNumber}',
            style: (widget.table.reserved ?? false)
                ? const TextStyle(
              decoration: TextDecoration.lineThrough,
            )
                : null,
        ),
        subtitle: Text(
          capacityText,
            style:
            TextStyle(
              color: widget.table.reserved! ? Colors.red : Colors.black,
            ),
        ),
        secondary: const Icon(Icons.table_restaurant),
      ),
    );
  }
}