import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prbd_2526_a04/core/widgets/service_card.dart';
import 'package:prbd_2526_a04/providers/my_restaurants_provider.dart';
import 'package:prbd_2526_a04/providers/restaurant_services_provider.dart';
import 'package:prbd_2526_a04/views/pages/restaurant_management_reservations_mockup.dart';

import '../../models/restaurant.dart';


class RestaurantManagementServicesMockupScreen extends ConsumerStatefulWidget {
  final int restaurantId;

  const RestaurantManagementServicesMockupScreen(
      {super.key, required this.restaurantId});

  @override
  ConsumerState<RestaurantManagementServicesMockupScreen> createState() =>
      _ScreenState();
}

class _ScreenState extends ConsumerState<RestaurantManagementServicesMockupScreen> {
  Restaurant? restaurant;

  // Future<void> loadRestaurant() async{
  //   final r =  await ref.read(myRestaurantsProvider.notifier).getRestaurantById(widget.restaurantId);
  //   setState(() {
  //     restaurant=r;
  //   });
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   loadRestaurant();
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      final notifier = ref.read(restaurantServicesProvider.notifier);
      if (notifier.state.value == null || notifier.state.value!.isEmpty) {
        notifier.loadServices(widget.restaurantId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(myRestaurantsProvider).value!.firstWhere((r) => r.restaurant.id == widget.restaurantId).restaurant;
    final servicesAsync = ref.watch(restaurantServicesProvider);
    final theme = Theme.of(context);
    final simulatedTime = DateTime(2024, 12, 4, 16, 0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RestaurantManagementReservationsMockupScreen(
                  restaurantId: widget.restaurantId,
                ),
              ),
            );
          },
        ),
        title: Text(restaurant.name),
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
                  DateFormat('EEEE dd/MM/yyyy HH:mm', 'fr_FR')
                      .format(simulatedTime),
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
        child: Stack(
          children: [
            servicesAsync.when(
              data: (services) => ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: services.length,
                  itemBuilder: (context,index){
                    final service = services[index];
                    return ServiceCard(
                      service: service,
                    );
                  }
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text(error.toString())),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                heroTag: 'services_fab',
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap: (index) {
          if(index==0){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RestaurantManagementReservationsMockupScreen(
                  restaurantId: widget.restaurantId,
                ),
              ),
            );
          } else if (index == 1) {
            return;
          } else if (index == 2) {
            Navigator.pushNamed(
              context,
              '/restaurant_tables',
              arguments: restaurant,
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_restaurant),
            label: 'Tables',
          ),
        ],
      ),
    );
  }
}
