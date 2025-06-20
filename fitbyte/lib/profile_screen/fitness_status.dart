import 'package:fitbyte/dashboard/calculation/calculation_controller.dart';
import 'package:fitbyte/dashboard/dashboard_controller.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FitnessStatsCard extends StatelessWidget {
  const FitnessStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final CalculatorController calcController = Get.find<CalculatorController>();

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fitness Stats',
                  style: themeController.theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  label: 'Weight',
                  value: controller.latestWeight.value > 0
                      ? '${controller.latestWeight.value.toStringAsFixed(1)} kg'
                      : 'Not recorded',
                  icon: Icons.fitness_center,
                ),
                _buildDetailRow(
                  label: 'BMI',
                  value: calcController.bmi.value > 0
                      ? calcController.bmi.value.toStringAsFixed(1)
                      : 'N/A',
                  icon: Icons.health_and_safety,
                ),
                _buildDetailRow(
                  label: 'Daily Calories',
                  value: calcController.calories.value > 0
                      ? '${calcController.calories.value.toStringAsFixed(0)} kcal'
                      : 'N/A',
                  icon: Icons.local_fire_department,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Get.find<ThemeController>().theme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}