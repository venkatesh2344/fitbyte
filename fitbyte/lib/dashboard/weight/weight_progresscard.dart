import 'package:fitbyte/dashboard/weight/weight_entry.dart';
import 'package:fitbyte/dashboard/weight/weight_records.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_controller.dart';
import 'weight_graph.dart';

class WeightProgressCard extends StatelessWidget {
  const WeightProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      final latestWeight = controller.latestWeight.value;
      final records = controller.weightRecords;

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.to(() => WeightRecordsPage()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.fitness_center, color: themeController.theme.primaryColor, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Weight Progress',
                          style: themeController.theme.textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      latestWeight > 0 ? 'Latest: $latestWeight kg' : 'No weight recorded',
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: records.isNotEmpty
                          ? WeightGraph(records: records)
                          : const Center(
                              child: Text(
                                'Add weight to see graph',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => showWeightEntryDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add Weight'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}