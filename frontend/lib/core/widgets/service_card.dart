import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/providers/restaurant_services_provider.dart';
import '../../models/service.dart';

class ServiceCard extends ConsumerStatefulWidget {
  final String dayLabel;
  final List<Service> filteredServices;
  const ServiceCard({
    super.key,
    required this.dayLabel,
    required this.filteredServices,
  });
  @override
  ConsumerState<ServiceCard> createState() => _ServiceCardState();
}
class _ServiceCardState extends ConsumerState<ServiceCard>{
  @override
  Widget build(BuildContext context) {
    final bool hasNoServices = widget.filteredServices.isEmpty;
    return
      Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: ExpansionTile(
          leading: const Icon(Icons.schedule),
          title:  Text(widget.dayLabel),
            subtitle: hasNoServices
                ? Text('Aucun service', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                : widget.filteredServices.length > 1
                ? Text('${widget.filteredServices.first.startTime} - ${widget.filteredServices.first.endTime} , ${widget.filteredServices.last.startTime} - ${widget.filteredServices.last.endTime} ')
                : Text('${widget.filteredServices.first.startTime} - ${widget.filteredServices.first.endTime}')
          ,
          children: [
            for(Service service in widget.filteredServices)
              ListTile(
              title:  Text('${service.startTime} - ${service.endTime}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: service.used_by_reservation! ? Colors.grey:Colors.red),
                    onPressed: service.used_by_reservation!
                        ? null
                        : () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Supprimer le service'),
                            content: Text('Êtes-vous sûr de vouloir supprimer le service du ${widget.dayLabel} (${service.startTime} - ${service.endTime}) ?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Ferme le modal
                                },
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final deleteService = await ref.read(restaurantServicesProvider.notifier).deleteService(service.id);
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Supprimer'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    tooltip: service.used_by_reservation! ? 'Impossible de supprimer : des réservations non annulées utilisent ce service' : 'Supprimer le service',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}