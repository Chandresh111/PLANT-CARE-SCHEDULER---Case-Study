import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/plant_care_scheduler_item.dart';
import '../../providers/plant_care_scheduler_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plants = ref.watch(plantCareSchedulerProvider);

    // Home shows all plants.
    // My Plants shows only plants added by the user.
    final displayedPlants = _selectedIndex == 0
        ? plants
        : plants
            .where((plant) => plant.isUserAdded)
            .toList();

    final filteredPlants = displayedPlants.where((plant) {
      final query = _searchQuery.trim().toLowerCase();

      if (query.isEmpty) {
        return true;
      }

      return plant.plantName.toLowerCase().contains(query) ||
          plant.species.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: const Text(
          'FloraFlora',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              12,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search plants...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 12,
                ),
              ),
            ),
          ),

          Expanded(
            child: filteredPlants.isEmpty
                ? Center(
                    child: Text(
                      _selectedIndex == 1
                          ? 'No plant added'
                          : 'No plants found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: filteredPlants.length,
                    itemBuilder: (context, index) {
                      final plant =
                          filteredPlants[index];

                      return InkWell(
                        onTap: () {
                          context.push(
                            '/details/${plant.id}',
                          );
                        },
                        borderRadius:
                            BorderRadius.circular(12),
                        child: PlantCard(
                          plant: plant,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add');
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _searchQuery = '';
            _searchController.clear();
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_florist_outlined),
            selectedIcon: Icon(Icons.local_florist),
            label: 'My Plants',
          ),
        ],
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final PlantCareSchedulerItem plant;

  const PlantCard({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 110,
        child: Row(
          children: [
            Container(
              width: 82,
              height: 82,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant,
                ),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8),
                child: Image.network(
                  plant.imageUrl,
                  width: 82,
                  height: 82,
                  fit: BoxFit.cover,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Icon(
                      Icons.local_florist,
                      size: 48,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    );
                  },
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  12,
                  8,
                  4,
                  8,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      plant.plantName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      plant.species,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Water every '
                      '${plant.wateringFrequency} days',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Last watered: '
                      '${plant.lastWateredDate.day} '
                      '${_monthName(
                        plant.lastWateredDate.month,
                      )} '
                      '${plant.lastWateredDate.year}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.chevron_right,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}