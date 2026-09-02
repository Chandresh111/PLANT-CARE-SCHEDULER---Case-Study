import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/plant_care_scheduler_item.dart';

class PlantCareSchedulerNotifier
    extends StateNotifier<List<PlantCareSchedulerItem>> {
  PlantCareSchedulerNotifier()
      : super([
          PlantCareSchedulerItem(
            id: '1',
            plantName: 'Aloe Vera',
            species: 'Succulent',
            wateringFrequency: 7,
            sunExposureNeeds: 'Bright Indirect',
            lastWateredDate: DateTime(2024, 5, 12),
            notes: 'Keep soil slightly moist.',
            imageUrl:
                'https://images.unsplash.com/photo-1509423350716-97f9360b4e09',
          ),
          PlantCareSchedulerItem(
            id: '2',
            plantName: 'Peace Lily',
            species: 'Flowering Plant',
            wateringFrequency: 4,
            sunExposureNeeds: 'Medium Indirect',
            lastWateredDate: DateTime(2024, 5, 10),
            notes: '',
            imageUrl:
                'https://www.bhg.com/thmb/qElXblu7QDEJ07avHDDVWSBNXIE=/1244x0/filters:no_upscale():strip_icc()/static.onecms.io__wp-content__uploads__sites__37__2020__09__23__outdoor-peace-lily-baaff9d7-9d11f7feabd84cc9a370056925e33d8a.jpg',
          ),
          PlantCareSchedulerItem(
            id: '3',
            plantName: 'Snake Plant',
            species: 'Indoor Plant',
            wateringFrequency: 10,
            sunExposureNeeds: 'Low Light',
            lastWateredDate: DateTime(2024, 5, 5),
            notes: '',
            imageUrl:
                'https://images.unsplash.com/photo-1593482892290-f54927ae2c6e',
          ),
          PlantCareSchedulerItem(
            id: '4',
            plantName: 'Money Plant',
            species: 'Vine',
            wateringFrequency: 5,
            sunExposureNeeds: 'Bright Indirect',
            lastWateredDate: DateTime(2024, 5, 11),
            notes: '',
            imageUrl:
                'https://images.unsplash.com/photo-1614594975525-e45190c55d0b',
          ),
        ]);

  void addPlant(PlantCareSchedulerItem plant) {
    state = [...state, plant];
  }

  void updatePlant(PlantCareSchedulerItem updatedPlant) {
    state = [
      for (final plant in state)
        if (plant.id == updatedPlant.id)
          updatedPlant
        else
          plant,
    ];
  }
}

final plantCareSchedulerProvider = StateNotifierProvider<
    PlantCareSchedulerNotifier,
    List<PlantCareSchedulerItem>>(
  (ref) => PlantCareSchedulerNotifier(),
);