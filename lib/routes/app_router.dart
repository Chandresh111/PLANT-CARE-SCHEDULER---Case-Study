import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/plant_care_scheduler_item.dart';
import '../providers/plant_care_scheduler_provider.dart';
import '../screens/add/add_plant_screen.dart';
import '../screens/details/details_screen.dart';
import '../screens/home/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),

    GoRoute(
      path: '/add',
      builder: (context, state) {
        return const AddPlantScreen();
      },
    ),

    GoRoute(
      path: '/details/:id',
      builder: (context, state) {
        final plantId =
            state.pathParameters['id'];

        return Consumer(
          builder:
              (context, ref, child) {
            final plants = ref.watch(
              plantCareSchedulerProvider,
            );

            PlantCareSchedulerItem?
                selectedPlant;

            for (final plant in plants) {
              if (plant.id == plantId) {
                selectedPlant = plant;
                break;
              }
            }

            if (selectedPlant == null) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Plant Details',
                  ),
                ),
                body: const Center(
                  child: Text(
                    'Plant not found',
                  ),
                ),
              );
            }

            return DetailsScreen(
              plant: selectedPlant,
            );
          },
        );
      },
    ),
  ],
);