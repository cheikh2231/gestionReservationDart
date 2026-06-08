import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/tools/validating_text_editing_controller.dart';
import '../../core/widgets/dialog_box.dart';
import '../../models/restaurant.dart';
import '../../models/table.dart' as model;
import '../../providers/reservation_provider.dart';
import '../../providers/system_time_provider.dart';
import '../../providers/tables_provider.dart';
import '../../core/widgets/simulated_time_display.dart';

class EditTableScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  final model.Table? tableToEdit;

  const EditTableScreen({
    super.key,
    required this.restaurant,
    this.tableToEdit,
  });

  @override
  ConsumerState<EditTableScreen> createState() => _EditTableScreenState();
}

class _EditTableScreenState extends ConsumerState<EditTableScreen> {
  late final ValidatingTextEditingController _tableNumberController;

  int _capacity = 2;

  @override
  void initState() {
    super.initState();

    String initialValue = widget.tableToEdit != null ? widget.tableToEdit!.tableNumber.toString() : '';

    _tableNumberController = ValidatingTextEditingController(
      initialValue: initialValue,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Le numéro est requis';
        if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Doit être un entier positif';

        final tables = ref.read(restaurantTablesProvider).value ?? [];
        final inputNumber = int.parse(value);
        bool exists = tables.any((t) => t.tableNumber == inputNumber && t.id != widget.tableToEdit?.id);

        if (exists) {
          return 'Ce numéro de table est déjà utilisé pour ce restaurant.';
        }
        return null;
      },
      onAfterValidated: () => setState(() {}),
    );

    if (widget.tableToEdit != null) {
      _capacity = widget.tableToEdit!.capacity;
    }
  }

  @override
  void dispose() {
    _tableNumberController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    _tableNumberController.validate();
    return _tableNumberController.isValid == true;
  }

  void _decrementCapacity() {
    if (_capacity <= 1) return;

    if (widget.tableToEdit != null) {
      final reservations = ref.read(reservationsProvider).value ?? [];
      bool canDecrease = true;

      for (var r in reservations) {
        if (r.status == 'confirmed' || r.status == 'completed') {
          bool usesThisTable = r.tables.any((t) => t.id == widget.tableToEdit!.id);
          if (usesThisTable) {
            // On calcule la nouvelle capacité totale de la réservation quand on diminue
            int newTotalCap = r.tables.fold(0, (sum, t) {
              if (t.id == widget.tableToEdit!.id) {
                return sum + (_capacity - 1);
              }
              return sum + t.capacity;
            });

            // Si la capacité totale devient inférieure au nombre de convives
            if (newTotalCap < r.numberOfGuests) {
              canDecrease = false;
              break;
            }
          }
        }
      }

      if (!canDecrease) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible de diminuer la capacité : une ou plusieurs réservations utilisent cette table et nécessitent au moins cette capacité.'),
            duration: Duration(seconds: 4),
          ),
        );
        return;
      }
    }
    setState(() {
      _capacity--;
    });
  }

  Future<void> _saveTable() async {
    if (!_validateForm()) return;

    try {
      await ref.read(restaurantTablesProvider.notifier).saveTable(
        tableNumber: int.parse(_tableNumberController.text),
        capacity: _capacity,
        tableId: widget.tableToEdit?.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.tableToEdit == null ? 'Table créée avec succès' : 'Table mise à jour avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      DialogBox(
        title: "Erreur de sauvegarde",
        message: e.toString().replaceAll('Exception: ', ''),
        actions: const ['OK'],
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final simulatedTimeState = ref.watch(systemTimeProvider);
    final isNew = widget.tableToEdit == null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isNew ? 'Nouvelle table' : 'Modifier la table'),
        actions: [
          IconButton(
            tooltip: 'Enregistrer',
            onPressed: _saveTable,
            icon: const Icon(Icons.save),
          ),
        ],
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: const SimulatedTimeDisplay(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _tableNumberController,
                decoration: InputDecoration(
                  labelText: 'Numéro de table',
                  border: const OutlineInputBorder(),
                  errorText: _tableNumberController.errorText,
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _tableNumberController.validate(),
              ),
              const SizedBox(height: 24),
              const Text('Capacité', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Tooltip(
                    message: _capacity == 1 ? 'Capacité minimale (1 personne)' : '',
                    child: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _capacity > 1 ? _decrementCapacity : null,
                    ),
                  ),
                  Text(
                    '$_capacity personne${_capacity > 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => _capacity++),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
