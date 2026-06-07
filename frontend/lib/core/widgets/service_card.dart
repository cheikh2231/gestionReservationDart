import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/service.dart';
import '../../providers/restaurant_services_provider.dart';

class ServiceCard extends StatefulWidget {
  final Service service;
  const ServiceCard({super.key, required this.service});
  @override
  State<ServiceCard> createState() => _ServiceCardState();
}
class _ServiceCardState extends State<ServiceCard>{

  @override
  Widget build(BuildContext context) {
    return
      Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: ExpansionTile(
          leading: const Icon(Icons.schedule),
          title:  Text(widget.service.dayName),
          subtitle:  Text('${widget.service.startTime}, ${widget.service.endTime}'),
          children: [
            ListTile(
              title: const Text('12:00 - 14:00'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {},
                    tooltip: 'Supprimer le service',
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('19:00 - 22:00'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey[400]),
                    onPressed: null,
                    tooltip:
                    'Impossible de supprimer : des réservations non annulées utilisent ce service',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}