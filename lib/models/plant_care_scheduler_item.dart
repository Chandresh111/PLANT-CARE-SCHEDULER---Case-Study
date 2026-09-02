class PlantCareSchedulerItem {
  final String id;
  final String plantName;
  final String species;
  final int wateringFrequency;
  final String sunExposureNeeds;
  final DateTime lastWateredDate;
  final String notes;
  final String imageUrl;
  final bool isUserAdded;

  PlantCareSchedulerItem({
    required this.id,
    required this.plantName,
    required this.species,
    required this.wateringFrequency,
    required this.sunExposureNeeds,
    required this.lastWateredDate,
    this.notes = '',
    required this.imageUrl,
    this.isUserAdded = false,
  });

  DateTime get nextWateringDate {
    return lastWateredDate.add(
      Duration(days: wateringFrequency),
    );
  }

  PlantCareSchedulerItem copyWith({
    String? plantName,
    String? species,
    int? wateringFrequency,
    String? sunExposureNeeds,
    DateTime? lastWateredDate,
    String? notes,
    String? imageUrl,
  }) {
    return PlantCareSchedulerItem(
      id: id,
      plantName: plantName ?? this.plantName,
      species: species ?? this.species,
      wateringFrequency:
          wateringFrequency ?? this.wateringFrequency,
      sunExposureNeeds:
          sunExposureNeeds ?? this.sunExposureNeeds,
      lastWateredDate:
          lastWateredDate ?? this.lastWateredDate,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      isUserAdded: isUserAdded,
    );
  }
}