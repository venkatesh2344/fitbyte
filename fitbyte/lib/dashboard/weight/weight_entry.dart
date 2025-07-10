import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../dashboard_controller.dart';
import 'package:fitbyte/dashboard/calculation/calculation_controller.dart';

void showWeightEntryDialog(BuildContext context) {
  // Ensure DashboardController is initialized
  if (!Get.isRegistered<DashboardController>()) {
    Get.put(DashboardController());
  }
  final controller = Get.find<DashboardController>();
  final TextEditingController weightController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Add Weight',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    errorText:
                        weightController.text.isNotEmpty &&
                                (double.tryParse(
                                          weightController.text.trim(),
                                        ) ==
                                        null ||
                                    double.parse(
                                          weightController.text.trim(),
                                        ) <=
                                        0)
                            ? 'Enter a valid weight'
                            : null,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                              onSurface: Colors.black87,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final weightText = weightController.text.trim();
              if (weightText.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please enter a weight',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                );
                return;
              }
              final weight = double.tryParse(weightText);
              if (weight == null || weight <= 0) {
                Get.snackbar(
                  'Error',
                  'Please enter a valid weight',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                );
                return;
              }
              try {
                await controller.addWeight(
                  weight,
                  selectedDate.toIso8601String().split('T')[0],
                );
                // Update CalculatorController's weight value
                if (Get.isRegistered<CalculatorController>()) {
                  final calcController = Get.find<CalculatorController>();
                  calcController.weight.value = weight;
                }
                Navigator.pop(context);
                Get.snackbar(
                  'Success',
                  'Weight added successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Theme.of(context).primaryColor,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to save weight: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ],
      );
    },
  );
}
