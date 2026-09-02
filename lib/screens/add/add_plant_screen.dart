import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/plant_care_scheduler_item.dart';
import '../../providers/plant_care_scheduler_provider.dart';

class AddPlantScreen extends ConsumerStatefulWidget {
  final PlantCareSchedulerItem? plantToEdit;

  const AddPlantScreen({
    super.key,
    this.plantToEdit,
  });

  @override
  ConsumerState<AddPlantScreen> createState() =>
      _AddPlantScreenState();
}

class _AddPlantScreenState
    extends ConsumerState<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();

  final _plantNameController =
      TextEditingController();

  final _speciesController =
      TextEditingController();

  final _wateringFrequencyController =
      TextEditingController();

  final _notesController =
      TextEditingController();

  String? _selectedSunExposure;

  DateTime? _lastWateredDate;

  final List<String> _sunExposureOptions = [
    'Bright Indirect',
    'Medium Indirect',
    'Low Light',
  ];

  bool get _isEditing => widget.plantToEdit != null;

  @override
  void initState() {
    super.initState();

    final plant = widget.plantToEdit;

    if (plant != null) {
      _plantNameController.text =
          plant.plantName;

      _speciesController.text =
          plant.species;

      _wateringFrequencyController.text =
          plant.wateringFrequency.toString();

      _selectedSunExposure =
          plant.sunExposureNeeds;

      _lastWateredDate =
          plant.lastWateredDate;

      _notesController.text =
          plant.notes;
    }
  }

  @override
  void dispose() {
    _plantNameController.dispose();
    _speciesController.dispose();
    _wateringFrequencyController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    final today = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate:
          _lastWateredDate ?? today,
      firstDate: DateTime(2000),
      lastDate: today,
    );

    if (selectedDate != null) {
      final selectedDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      final currentDay = DateTime(
        today.year,
        today.month,
        today.day,
      );

      if (selectedDay.isAfter(currentDay)) {
        return;
      }

      setState(() {
        _lastWateredDate = selectedDate;
      });
    }
  }

  void _savePlant() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSunExposure == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select sun exposure needs.',
          ),
        ),
      );
      return;
    }

    final wateringFrequency =
        int.tryParse(
      _wateringFrequencyController.text
          .trim(),
    );

    if (wateringFrequency == null ||
        wateringFrequency <= 0) {
      return;
    }

    final lastWateredDate =
        _lastWateredDate ?? DateTime.now();

    if (_isEditing) {
      final updatedPlant =
          widget.plantToEdit!.copyWith(
        plantName:
            _plantNameController.text.trim(),
        species:
            _speciesController.text.trim(),
        wateringFrequency:
            wateringFrequency,
        sunExposureNeeds:
            _selectedSunExposure!,
        lastWateredDate:
            lastWateredDate,
        notes:
            _notesController.text.trim(),
      );

      ref
          .read(
            plantCareSchedulerProvider.notifier,
          )
          .updatePlant(updatedPlant);
    } else {
      final plant =
          PlantCareSchedulerItem(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        plantName:
            _plantNameController.text.trim(),
        species:
            _speciesController.text.trim(),
        wateringFrequency:
            wateringFrequency,
        sunExposureNeeds:
            _selectedSunExposure!,
        lastWateredDate:
            lastWateredDate,
        notes:
            _notesController.text.trim(),

        // Default image for newly added plants.
        imageUrl:
            'https://images.unsplash.com/photo-1509423350716-97f9360b4e09',

        // This makes it appear in My Plants.
        isUserAdded: true,
      );

      ref
          .read(
            plantCareSchedulerProvider.notifier,
          )
          .addPlant(plant);
    }

    context.go('/');
  }

  String _formatDate(DateTime date) {
    return '${date.day} '
        '${_monthName(date.month)} '
        '${date.year}';
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

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),

        title: Text(
          _isEditing
              ? 'Edit Plant'
              : 'Add Plant',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: _savePlant,
            icon: const Icon(Icons.check),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plant Name *',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller:
                      _plantNameController,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Enter plant name',
                    filled: true,
                    fillColor: colors
                        .surfaceContainerHighest,
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Please enter plant name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                const Text(
                  'Species *',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller:
                      _speciesController,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Enter species',
                    filled: true,
                    fillColor: colors
                        .surfaceContainerHighest,
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Please enter species';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                const Text(
                  'Watering Frequency (days) *',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller:
                      _wateringFrequencyController,
                  keyboardType:
                      TextInputType.number,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Enter number of days',
                    suffixText: 'days',
                    filled: true,
                    fillColor: colors
                        .surfaceContainerHighest,
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Please enter watering frequency';
                    }

                    final days =
                        int.tryParse(
                      value.trim(),
                    );

                    if (days == null ||
                        days <= 0) {
                      return 'Enter a valid number of days';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                const Text(
                  'Sun Exposure Needs *',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  initialValue:
                      _selectedSunExposure,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Select sun exposure',
                    filled: true,
                    fillColor: colors
                        .surfaceContainerHighest,
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                  items:
                      _sunExposureOptions
                          .map(
                    (option) =>
                        DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSunExposure =
                          value;
                    });
                  },
                ),

                const SizedBox(height: 18),

                const Text(
                  'Last Watered Date',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                InkWell(
                  onTap: _selectDate,
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                  child: InputDecorator(
                    decoration:
                        InputDecoration(
                      filled: true,
                      fillColor: colors
                          .surfaceContainerHighest,
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                        borderSide:
                            BorderSide.none,
                      ),
                      suffixIcon:
                          const Icon(
                        Icons.calendar_today,
                      ),
                    ),
                    child: Text(
                      _lastWateredDate == null
                          ? 'Select date'
                          : _formatDate(
                              _lastWateredDate!,
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Notes (Optional)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller:
                      _notesController,
                  maxLines: 4,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Enter any notes...',
                    filled: true,
                    fillColor: colors
                        .surfaceContainerHighest,
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  '* Required Field',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors
                        .onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}