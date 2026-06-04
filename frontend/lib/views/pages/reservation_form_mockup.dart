import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/providers/reservation_provider.dart';

import '../../core/tools/validating_text_editing_controller.dart';
import '../../models/reservation.dart';
import '../../models/restaurant.dart';
import '../../providers/system_time_provider.dart';

void main() async {
  await initializeDateFormatting('fr_FR', null);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ReservationFormMockupScreen(),
    ),
  );
}

class ReservationFormMockupScreen extends ConsumerStatefulWidget {
  const ReservationFormMockupScreen({super.key});

  @override
  ConsumerState<ReservationFormMockupScreen> createState() =>
      _ReservationFormMockupScreen();
}

class _ReservationFormMockupScreen
    extends ConsumerState<ReservationFormMockupScreen> {
  bool _initialized = false;
  late int _nbGuests;
  String _nameResto = '';
  DateTime? _selectedDate;
  Reservation? _reservation;
  bool? isClosed = false;
  DateTime? _simulatedTime;
  List<String> _slots = [];
  String? _selectedSlot;
  bool _noTableDispo = false;
  Timer? _debounceTimer;
  final _specialRequestController = ValidatingTextEditingController(
    validator: Reservation.validateSpecialRequest,
    initialValue: '',
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final systemTimeAsync = ref.read(systemTimeProvider);
    _simulatedTime =
        systemTimeAsync.value?.first.simulated_time ?? DateTime.now();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _reservation = args?['reservation'] as Reservation?;

    if (_reservation != null) {
      _nbGuests = _reservation!.numberOfGuests;
      _nameResto = _reservation!.restaurant.name;
      _selectedDate = _reservation!.datetime;
      _specialRequestController.text = _reservation!.specialRequests ?? '';
      _loadSlots(_reservation!);
      _selectedSlot = DateFormat('HH:mm').format(_reservation!.datetime);
    } else {
      _specialRequestController.text = '';
      _nbGuests = 2;
      _nameResto = 'brol';
      _selectedDate = _simulatedTime;
    }

    _initialized = true;
  }

  bool canTMod() {
    return (isClosed! ||
        _selectedSlot == null ||
        _selectedDate == null ||
        _nbGuests < 1 ||
        _specialRequestController.errorText != null);
  }

  Future<void> haveTables() async {
    if (_selectedSlot == null ||
        _selectedDate == null ||
        _reservation == null) {
      setState(() => _noTableDispo = false);
      return;
    }
    final result = await _reservation!.restaurant.noTableDispo(
      _selectedDate!,
      _selectedSlot!,
      _nbGuests,
      _reservation?.id,
    );
    print(result);
    setState(() => _noTableDispo = result);
  }

  void onGuestsChanged() {
    if (_selectedSlot == null) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      haveTables();
    });
  }

  void refreshDateAndClosedRestaurantDays(
    Reservation? reservation,
    int days,
  ) async {

    DateTime? datePlusOrMinusOne;
    if (days > 0) {
      if (canAdd()) {
        datePlusOrMinusOne = _selectedDate?.add(Duration(days: days));
        if (datePlusOrMinusOne == null) return;
        setState(() {
          _selectedDate = datePlusOrMinusOne;
          haveTables();
        });
      }
    } else {
      if (canRemove()) {
        datePlusOrMinusOne = _selectedDate?.add(Duration(days: days));
        if (datePlusOrMinusOne == null) return;
        setState(() {
          _selectedDate = datePlusOrMinusOne;
          haveTables();
        });
      }
    }

    await _loadSlots(reservation!);
    if(_selectedSlot==null){
      _noTableDispo = false;
    }
    bool isResClosed = false;
    try {
      final listClosedDay = reservation != null
          ? await Restaurant.getClosedDays(reservation.restaurant.id)
          : await Restaurant.getClosedDays(5);
      isResClosed = listClosedDay.contains(datePlusOrMinusOne!.weekday);
    } catch (e) {
      print(e.toString());
      print('pas bonnnnnnnnnnnnnnnnnnnnnnn');
      return;
    }
    setState(() {
      isClosed = isResClosed;
    });
  }

  Future<bool> updateReservationInDatabase(Reservation updated) async {
    try {
      return await ref
          .read(reservationsProvider.notifier)
          .updateReservation(updated);
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadSlots(Reservation reservation) async {
    if (_selectedDate != null) {
      print(_simulatedTime);
      print(_selectedDate);
      final slots = await reservation.restaurant.getSlots(
        _selectedDate!,
        _simulatedTime!,
      );
      setState(()  {
        _slots = slots;
        if (_selectedSlot != null && !slots.contains(_selectedSlot)) {
          _selectedSlot = null;
          _noTableDispo = false;
        }
      });
      await haveTables();
    }
  }
  bool canRemove() {
    final dateBefore = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    ).subtract(const Duration(days: 1));

    final today = DateTime(
      _simulatedTime!.year,
      _simulatedTime!.month,
      _simulatedTime!.day,
    );

    return !dateBefore.isBefore(today);
  }

  bool canAdd() {
    return _selectedDate!
            .add(Duration(days: 1))
            .compareTo(_simulatedTime!.add(Duration(days: 365))) <=
        0;
  }

  @override
  Widget build(BuildContext context) {
    final systemTimeAsync = ref.watch(systemTimeProvider);
    _simulatedTime =
        systemTimeAsync.value?.first.simulated_time ?? DateTime.now();
    _specialRequestController.onAfterValidated = () => setState(() {});
    if (!_initialized) {
      _selectedDate = _reservation?.datetime ?? _simulatedTime;
      _initialized = true;
    }

    final theme = Theme.of(context);
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final reservation = args?['reservation'] as Reservation?;
    final isNew = reservation == null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text((isNew) ? 'Nouvelle réservation' : 'Modifier réservation'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir les données',
            onPressed: () {},
          ),
        ],
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Tooltip(
                message:
                    'Date/heure simulée utilisée pour les tests.\nCliquez pour modifier.',
                child: Text(
                  DateFormat(
                    'EEEE dd/MM/yyyy HH:mm',
                    'fr_FR',
                  ).format(_simulatedTime!),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _nameResto,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate!,
                              firstDate: _simulatedTime!,
                              lastDate: _simulatedTime!.add(
                                const Duration(days: 365),
                              ),
                              locale: const Locale('fr', 'FR'),
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Date'),
                                      Text(
                                        DateFormat(
                                          'EEEE dd/MM/yyyy',
                                          'fr_FR',
                                        ).format(
                                          _selectedDate ?? _simulatedTime!,
                                        ),
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: !canRemove()
                          ? null
                          : () {
                              refreshDateAndClosedRestaurantDays(
                                reservation,
                                -1,
                              );
                            },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: !canAdd()
                          ? null
                          : () async {
                              refreshDateAndClosedRestaurantDays(
                                reservation,
                                1,
                              );
                            },
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const Divider(),
                if (isClosed == true)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),

                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange),
                        const SizedBox(width: 8),

                        const Expanded(
                          child: Text(
                            'Le restaurant est fermé ce jour-là.',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                if (isClosed == false)
                  const Text(
                    'Créneaux disponibles',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                if (isClosed == false) const SizedBox(height: 12),
                if (isClosed == false)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      for (final slot in _slots)
                        InkWell(
                          onTap: () {
                            setState(() => _selectedSlot = slot);
                            haveTables();
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 80,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedSlot == slot
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                slot,
                                style: TextStyle(
                                  color: _selectedSlot == slot
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (isClosed == false) const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Nombre de convives'),
                  subtitle: Text('$_nbGuests'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: (_nbGuests - 1 <= 0)
                            ? null
                            : () {
                                setState(() {
                                  _nbGuests--;
                                });
                                onGuestsChanged();
                              },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _nbGuests++;
                          });
                          onGuestsChanged();
                        },
                      ),
                    ],
                  ),
                ),
                if (_noTableDispo)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.orange),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Surréservation (capacité)',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'La capacité du restaurant pour ce créneau pourrait être insuffisante pour le nombre de convives demandé.',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _specialRequestController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Demandes spéciales (optionnel)',
                    border: const OutlineInputBorder(),
                    hintText: 'Allergies, préférences...',
                    errorText: _specialRequestController.errorText,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: canTMod()
                      ? null
                      : () async {
                          if (isNew) {
                          } else {
                            final String dateString = DateFormat(
                              'yyyy-MM-dd',
                            ).format(_selectedDate!);
                            final DateTime finalDateTime = DateTime.parse(
                              "$dateString $_selectedSlot:00",
                            );

                            Reservation updatedReservation = _reservation!
                                .copyWith(
                                  datetime: finalDateTime,
                                  numberOfGuests: _nbGuests,
                                specialRequests: _specialRequestController.text.trim().isEmpty
                                    ? null
                                    : _specialRequestController.text,
                                );

                            if (needsConfirmationDialog(
                              _reservation!,
                              updatedReservation,
                            )) {
                              final confirmed =
                                  await showConfirmModificationDialog();
                              if (!confirmed) return;
                              updatedReservation = updatedReservation.copyWith(
                                status: 'pending',
                              );
                            }

                            final success = await updateReservationInDatabase(
                              updatedReservation,
                            );

                            if (context.mounted) {
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Réservation modifiée avec succès !',
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Échec de la modification.'),
                                  ),
                                );
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: Icon(isNew ? Icons.add : Icons.edit),
                  label: Text(
                    isNew ? 'Créer la réservation' : 'Modifier la réservation',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool needsConfirmationDialog(Reservation original, Reservation updated) {
    if (original.status != 'confirmed') return false;

    final hasChanges =
        original.datetime != updated.datetime ||
        original.numberOfGuests != updated.numberOfGuests;

    return hasChanges;
  }

  Future<bool> showConfirmModificationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier une réservation confirmée'),
        content: const Text(
          'Cette réservation est confirmée. La modifier la remettra en attente '
          'et les tables associées seront libérées. Souhaitez-vous continuer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade300),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
