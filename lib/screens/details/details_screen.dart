import 'package:flutter/material.dart';

import '../../models/plant_care_scheduler_item.dart';

import 'package:go_router/go_router.dart';

class DetailsScreen extends StatelessWidget {
  final PlantCareSchedulerItem plant;

  const DetailsScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Plant Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/add', extra: plant);
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Plant image
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    plant.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.local_florist,
                        size: 80,
                        color: colors.primary,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Plant name
              Text(
                plant.plantName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              // Species
              Text(
                plant.species,
                style: TextStyle(fontSize: 15, color: colors.onSurfaceVariant),
              ),

              const SizedBox(height: 22),

              // Details card
              Card(
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.water_drop_outlined,
                      label: 'Watering Frequency',
                      value: '${plant.wateringFrequency} days',
                    ),

                    _DetailDivider(),

                    _DetailRow(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Sun Exposure',
                      value: plant.sunExposureNeeds,
                    ),

                    _DetailDivider(),

                    _DetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Last Watered',
                      value: _formatDate(plant.lastWateredDate),
                    ),

                    _DetailDivider(),

                    _DetailRow(
                      icon: Icons.notifications_none,
                      label: 'Next Watering',
                      value: _formatDate(plant.nextWateringDate),
                    ),

                    _DetailDivider(),

                    _DetailRow(
                      icon: Icons.notes_outlined,
                      label: 'Notes',
                      value: plant.notes.isEmpty ? 'No notes' : plant.notes,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: colors.onSurface),
            ),
          ),

          const SizedBox(width: 12),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
