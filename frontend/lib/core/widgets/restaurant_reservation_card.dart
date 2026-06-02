import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/reservation.dart';
import '../../models/restaurant.dart';
import '../../views/pages/reservation_details_manager_mockup.dart';


class RestaurantReservationCard extends StatelessWidget {
  const RestaurantReservationCard({super.key,required this.restaurant, required this.reservation,required this.status});
  final Restaurant restaurant;
  final Reservation reservation;
  final String status;
  @override
  Widget build(BuildContext context) {
    final reservationDateFormated = DateFormat('E dd/MM/yyyy', 'fr_FR').format(reservation.datetime);
    final Map<String, ({IconData icon, Color color})> statusIcons = {
      'all': (icon: Icons.list, color: Colors.grey),
      'pending': (icon: Icons.pending, color: Colors.orange),
      'confirmed': (icon: Icons.check_circle, color: Colors.green),
      'completed': (icon: Icons.event_available, color: Colors.blue),
      'cancelled': (icon: Icons.cancel, color: Colors.red),
    };
    final reservationIcon = statusIcons[reservation.status] ?? (icon: Icons.error, color: Colors.grey);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReservationDetailsManagerMockupScreen(
                reservationId: reservation.id,
              ),
            ),
          );
          },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
               SizedBox(
                width: 32,
                height: 32,
                child: Icon(reservationIcon.icon, size: 32, color: reservationIcon.color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${reservation.client.fullName}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.restaurant, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.name,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          reservationDateFormated,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.people, size: 16),
                        const SizedBox(width: 4),
                        Text(
                            '${reservation.numberOfGuests} ' '${reservation.numberOfGuests > 1 ? "convives" : "convive"}',
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