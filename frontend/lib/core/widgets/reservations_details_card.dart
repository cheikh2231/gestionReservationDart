import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/models/reservation.dart';

import '../../models/reservation_details.dart';

class ReservationDetailCard extends StatelessWidget {
  final ReservationDetails reservationDetails;

  const ReservationDetailCard({
    super.key,
    required this.reservationDetails,
  });

  Color get _statusColor => switch (reservationDetails.base.status) {
    'pending'   => const Color(0xFFFF9800),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reservationDetails.restaurantName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    reservationDetails.restaurantAddress,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  reservationDetails.restaurantPhone,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text('Date: ${DateFormat('EEE dd/MM/yyyy', 'fr_FR').format(reservationDetails.base.datetime)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 8),
                Text('Heure: ${DateFormat('HH:mm').format(reservationDetails.base.datetime)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, size: 20),
                const SizedBox(width: 8),
                Text('Nombre de convives: ${reservationDetails.base.numberOfGuests}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info, size: 20),
                const SizedBox(width: 8),
                const Text('Statut: '),
                Chip(
                  label: Text(
                    _statusLabel,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  backgroundColor: _statusColor,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            if (reservationDetails.base.specialRequests != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Demandes spéciales',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                reservationDetails.base.specialRequests!,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}