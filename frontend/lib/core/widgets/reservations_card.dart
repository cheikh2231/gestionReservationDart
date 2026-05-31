import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/models/reservation.dart';
import 'package:prbd_2526_a04/models/reservation_client.dart';

class ReservationCard extends StatelessWidget {
  final VoidCallback onTap;
  final ReservationDetails reservationDetails;
  const ReservationCard({
    super.key,
    required this.reservationDetails,
    required this.onTap,
  });

  IconData get _statusIcon => switch (reservationDetails.base.status) {
    'pending'   => Icons.pending,
    'confirmed' => Icons.check_circle,
    'completed' => Icons.event_available,
    'cancelled' => Icons.cancel,
    _           => Icons.help,
  };

  Color get _statusColor => switch (reservationDetails.base.status) {
    'pending'   => Colors.orange,
    'confirmed' => Colors.green,
    'completed' => Colors.blue,
    'cancelled' => Colors.red,
    _           => Colors.grey,
  };

  String get _statusLabel => switch (reservationDetails.base.status) {
    'pending'   => 'En attente',
    'confirmed' => 'Confirmée',
    'completed' => 'Terminée',
    'cancelled' => 'Annulée',
    _           => '',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Tooltip(
                message: _statusLabel,
                child: Icon(_statusIcon, size: 32, color: _statusColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservationDetails.restaurantName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          reservationDetails.restaurantAddress,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('EEE dd/MM/yyyy à HH:mm', 'fr_FR').format(reservationDetails.base.datetime),
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.people, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${reservationDetails.base.numberOfGuests} convives',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}