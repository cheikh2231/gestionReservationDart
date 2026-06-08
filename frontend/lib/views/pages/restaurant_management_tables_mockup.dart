import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/restaurant.dart';
import '../../providers/system_time_provider.dart';
import '../../providers/tables_provider.dart';
import '../../core/widgets/simulated_time_display.dart';

class RestaurantManagementTablesScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  const RestaurantManagementTablesScreen({super.key, required this.restaurant});

  @override
  ConsumerState<RestaurantManagementTablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends ConsumerState<RestaurantManagementTablesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(restaurantTablesProvider.notifier).loadTables(widget.restaurant.id));
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final simulatedTimeState = ref.watch(systemTimeProvider);
    final tablesAsync = ref.watch(restaurantTablesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.restaurant.name),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir les données',
            onPressed: () => ref.read(restaurantTablesProvider.notifier).loadTables(widget.restaurant.id),
          ),
        ],
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: const SimulatedTimeDisplay(),
      ),
      body: SafeArea(
        child: tablesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text("Erreur : $error")),
          data: (tables) {
            if (tables.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    "Aucune table n'est configurée.\nAppuyez sur le bouton + pour en ajouter une.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final table = tables[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.table_restaurant, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Table ${table.tableNumber}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.people, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${table.capacity} personne${table.capacity > 1 ? 's' : ''}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(context, '/edit_table', arguments: {
                              'restaurant': widget.restaurant,
                              'table': table,
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'tables_fab',
        onPressed: () {
          Navigator.pushNamed(context, '/edit_table', arguments: {
            'restaurant': widget.restaurant,
          });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }else if (index == 1) {
            //service
          }else if(index == 2){
            return;
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