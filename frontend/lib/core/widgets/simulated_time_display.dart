import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/system_time_provider.dart';

class SimulatedTimeDisplay extends ConsumerWidget {
  const SimulatedTimeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulatedTimeState = ref.watch(systemTimeProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: simulatedTimeState.when(
            data: (list) {
              final simulatedDate = list.isNotEmpty ? list.first.simulated_time : null;
              final dateString = simulatedDate != null
                  ? DateFormat('EEEE dd/MM/yyyy HH:mm', 'fr_FR').format(simulatedDate)
                  : DateFormat('EEEE dd/MM/yyyy HH:mm', 'fr_FR').format(DateTime.now());

              return Tooltip(
                message: 'Date/heure simulée. Cliquez pour modifier.',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showTimeTravelDialog(context, ref, simulatedDate),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      child: Text(
                        dateString,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            loading: () => const Text("...", style: TextStyle(fontSize: 10, color: Colors.grey)),
            error: (err, _) => const Text("Erreur Temps", style: TextStyle(fontSize: 10, color: Colors.red)),
          ),
        ),
      ),
    );
  }

  void _showTimeTravelDialog(BuildContext context, WidgetRef ref, DateTime? currentDate) {
    showDialog(
      context: context,
      builder: (ctx) => _TimeTravelDialog(initialDate: currentDate),
    ).then((newDate) {
      if (newDate == 'null') {
        ref.read(systemTimeProvider.notifier).updateTime(null);
      } else if (newDate is DateTime) {
        ref.read(systemTimeProvider.notifier).updateTime(newDate);
      }
    });
  }
}

class _TimeTravelDialog extends StatefulWidget {
  final DateTime? initialDate;
  const _TimeTravelDialog({this.initialDate});

  @override
  State<_TimeTravelDialog> createState() => _TimeTravelDialogState();
}

class _TimeTravelDialogState extends State<_TimeTravelDialog> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    final init = widget.initialDate ?? DateTime.now();
    selectedDate = init;
    selectedTime = TimeOfDay(hour: init.hour, minute: init.minute);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Voyage dans le temps'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Date'),
            subtitle: Text(DateFormat('dd/MM/yyyy', 'fr_FR').format(selectedDate)),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                locale: const Locale('fr', 'FR'),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Heure'),
            subtitle: Text(
              '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                ),
              );
              if (picked != null) setState(() => selectedTime = picked);
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        TextButton(
          onPressed: () => Navigator.pop(context, 'null'),
          child: const Text('Effacer(null)'),
        ),
        ElevatedButton(
          onPressed: () {
            final finalDateTime = DateTime(
              selectedDate.year, selectedDate.month, selectedDate.day,
              selectedTime.hour, selectedTime.minute,
            );
            Navigator.pop(context, finalDateTime);
          },
          child: const Text('Valider'),
        ),
      ],
    );
  }
}