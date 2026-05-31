import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/models/old_restaurant.dart';
import 'package:prbd_2526_a04/models/old_restaurant_reservations_management.dart';

import '../../views/pages/restaurant_management_reservations_mockup.dart';


class RestaurantCard extends StatelessWidget{
  const RestaurantCard({super.key, required this.restaurantReservationManagement});
  final RestaurantReservationsManagement restaurantReservationManagement;

  @override
  Widget build(BuildContext context) {
    final restaurant = restaurantReservationManagement.base;
    final lastReservation = restaurantReservationManagement.lastReservation != null ? 'Dernière réservation: ${DateFormat('E dd/MM/yyyy', 'fr_FR').format(restaurantReservationManagement.lastReservation!)}' : "";
    final nbPendingReservation = restaurantReservationManagement.nbPendingReservation != null && restaurantReservationManagement.nbPendingReservation! > 0? '${restaurantReservationManagement.nbPendingReservation} demande${restaurantReservationManagement.nbPendingReservation! > 1 ? 's ' : ''}en attente' : "";
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.restaurant, size: 40),
        title: Text(restaurant.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(restaurant.city),
                const SizedBox(width: 12),
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  restaurant.rating.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Text(
                  '€'* restaurant.priceRange!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if(lastReservation.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    lastReservation,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            const SizedBox(height: 4),
            if (nbPendingReservation.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.pending, size: 14, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    nbPendingReservation,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RestaurantManagementReservationsMockupScreen(
                restaurant: restaurant, // On passe l'objet du restaurant pour l'utiliser dans la view et afficher le bon resto
              ),
            ),
          );
        },
      ),
    );
  }

}