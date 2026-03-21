import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/localization/app_localizations.dart';

class OccupancyHeatmap extends StatelessWidget {
  const OccupancyHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data: 30 days, random occupancy
    final now = DateTime.now();
    final days = List.generate(30, (i) => now.subtract(Duration(days: 29 - i)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.t('occupancyHeatmapLast30Days'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: days.map((date) {
                // Random intensity 0.0 to 1.0
                final intensity = (date.day % 5) / 4.0;
                return Tooltip(
                  message:
                      '${DateFormat.MMMd().format(date)}: ${(intensity * 100).toInt()}%',
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green
                          .withOpacity(intensity == 0 ? 0.1 : intensity),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
