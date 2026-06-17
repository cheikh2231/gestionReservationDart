import 'package:flutter/material.dart';
import 'package:prbd_2526_a04/models/service.dart';
import '../../core/widgets/simulated_time_display.dart';

class EditServiceMockupScreen extends StatefulWidget {
  final int restaurantID;
  final int slotDuration;
  final Service service;

  const EditServiceMockupScreen({
    super.key,
    required this.restaurantID,
    required this.slotDuration,
    required this.service,
  });

  @override
  State<EditServiceMockupScreen> createState() => EditServiceMockupScreenState();
}

class EditServiceMockupScreenState extends State<EditServiceMockupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String selectedDay = 'Mercredi';
  int? startHour = 19;
  int? startMinute = 0;
  int? endHour = 22;
  int? endMinute = 0;
  String? timeError;
  String? businessWarning;

  late String originalDay;
  late int originalStartHour;
  late int originalStartMinute;
  late int originalEndHour;
  late int originalEndMinute;

  @override
  void initState() {
    super.initState();

    if (widget.service.dayOfWeek == 1) {
      selectedDay = 'Lundi';
    } else if (widget.service.dayOfWeek == 2) {
      selectedDay = 'Mardi';
    } else if (widget.service.dayOfWeek == 3) {
      selectedDay = 'Mercredi';
    } else if (widget.service.dayOfWeek == 4) {
      selectedDay = 'Jeudi';
    } else if (widget.service.dayOfWeek == 5) {
      selectedDay = 'Vendredi';
    } else if (widget.service.dayOfWeek == 6) {
      selectedDay = 'Samedi';
    } else if (widget.service.dayOfWeek == 7) {
      selectedDay = 'Dimanche';
    }

    final startParts = widget.service.startTime.split(':');
    startHour = int.parse(startParts[0]);
    startMinute = int.parse(startParts[1]);

    final endParts = widget.service.endTime.split(':');
    endHour = int.parse(endParts[0]);
    endMinute = int.parse(endParts[1]);

    originalDay = selectedDay;
    originalStartHour = startHour!;
    originalStartMinute = startMinute!;
    originalEndHour = endHour!;
    originalEndMinute = endMinute!;

    timeError = _validateTimeRange();
    businessWarning = null;
  }

  String? _validateTimeRange() {
    if (startHour == null ||
        startMinute == null ||
        endHour == null ||
        endMinute == null) {
      return null;
    }

    final int startTotal = startHour! * 60 + startMinute!;
    final int endTotal = endHour! * 60 + endMinute!;
    final int slotDuration = widget.slotDuration;

    if (startMinute! % slotDuration != 0) {
      return 'L\'heure de début doit respecter les créneaux du restaurant';
    }

    if (endMinute! % slotDuration != 0) {
      return 'L\'heure de fin doit respecter les créneaux du restaurant';
    }

    if (endTotal <= startTotal) {
      return 'L\'heure de fin doit être après l\'heure de début';
    }
    return null;
  }

  int _getDayOfWeek() {
    if (selectedDay == 'Lundi') return 1;
    if (selectedDay == 'Mardi') return 2;
    if (selectedDay == 'Mercredi') return 3;
    if (selectedDay == 'Jeudi') return 4;
    if (selectedDay == 'Vendredi') return 5;
    if (selectedDay == 'Samedi') return 6;
    return 7;
  }

  bool _hasChanged() {
    return selectedDay != originalDay ||
        startHour != originalStartHour ||
        startMinute != originalStartMinute ||
        endHour != originalEndHour ||
        endMinute != originalEndMinute;
  }

  Future<void> _checkBusinessWarning() async {
    if (!_hasChanged()) {
      setState(() {
        businessWarning = null;
      });
      return;
    }

    if (startHour == null ||
        startMinute == null ||
        endHour == null ||
        endMinute == null) {
      return;
    }

    if (_validateTimeRange() != null) {
      setState(() {
        businessWarning = null;
      });
      return;
    }

    final String startTime =
        '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}:00';

    final String endTime =
        '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}:00';

    try {
      final int count = await Service.checkRestaurantServiceReservations(
        serviceId: widget.service.id,
        dayOfWeek: _getDayOfWeek(),
        startTime: startTime,
        endTime: endTime,
      );

      if (!mounted) return;

      setState(() {
        if (count == 0) {
          businessWarning = null;
        } else if (count == 1) {
          businessWarning =
          'Modification impossible : 1 réservation confirmée ou en attente serait en dehors des horaires du service.';
        } else {
          businessWarning =
          'Modification impossible : $count réservations confirmées ou en attente seraient en dehors des horaires du service.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        businessWarning = 'Erreur lors de la vérification.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Modifier le service'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Enregistrer',
            onPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              setState(() {
                timeError = _validateTimeRange();
              });

              if (timeError != null) {
                return;
              }

              await _checkBusinessWarning();

              if (businessWarning != null) {
                return;
              }

              final String formattedStartTime =
                  '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';

              final String formattedEndTime =
                  '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

              try {
                final updatedService = await Service.updateService(
                  serviceId: widget.service.id,
                  dayOfWeek: _getDayOfWeek(),
                  startTime: formattedStartTime,
                  endTime: formattedEndTime,
                );

                if (!mounted) return;

                Navigator.of(context).pop(updatedService);
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur lors de la modification : $e'),
                  ),
                );
              }
            },
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
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedDay,
                  decoration: const InputDecoration(
                    labelText: 'Jour',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Lundi', child: Text('Lundi')),
                    DropdownMenuItem(value: 'Mardi', child: Text('Mardi')),
                    DropdownMenuItem(value: 'Mercredi', child: Text('Mercredi')),
                    DropdownMenuItem(value: 'Jeudi', child: Text('Jeudi')),
                    DropdownMenuItem(value: 'Vendredi', child: Text('Vendredi')),
                    DropdownMenuItem(value: 'Samedi', child: Text('Samedi')),
                    DropdownMenuItem(value: 'Dimanche', child: Text('Dimanche')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDay = value!;
                    });
                    _checkBusinessWarning();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez choisir un jour';
                    }
                    return null;
                  },
                ),
                if (businessWarning != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.error,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          businessWarning!,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        initialValue: startHour,
                        decoration: const InputDecoration(
                          labelText: 'Heure de début (heure)',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          for (int h = 0; h < 24; h++)
                            DropdownMenuItem<int?>(
                              value: h,
                              child: Text('${h.toString().padLeft(2, '0')} h'),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            startHour = value;
                            timeError = _validateTimeRange();
                          });
                          _checkBusinessWarning();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Champ requis';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        initialValue: startMinute,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem<int?>(value: 0, child: Text('00 min')),
                          DropdownMenuItem<int?>(value: 15, child: Text('15 min')),
                          DropdownMenuItem<int?>(value: 30, child: Text('30 min')),
                          DropdownMenuItem<int?>(value: 45, child: Text('45 min')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            startMinute = value;
                            timeError = _validateTimeRange();
                          });
                          _checkBusinessWarning();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Champ requis';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        initialValue: endHour,
                        decoration: const InputDecoration(
                          labelText: 'Heure de fin (heure)',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          for (int h = 0; h < 24; h++)
                            DropdownMenuItem<int?>(
                              value: h,
                              child: Text('${h.toString().padLeft(2, '0')} h'),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            endHour = value;
                            timeError = _validateTimeRange();
                          });
                          _checkBusinessWarning();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Champ requis';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        initialValue: endMinute,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem<int?>(value: 0, child: Text('00 min')),
                          DropdownMenuItem<int?>(value: 15, child: Text('15 min')),
                          DropdownMenuItem<int?>(value: 30, child: Text('30 min')),
                          DropdownMenuItem<int?>(value: 45, child: Text('45 min')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            endMinute = value;
                            timeError = _validateTimeRange();
                          });
                          _checkBusinessWarning();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Champ requis';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                if (timeError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    timeError!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}