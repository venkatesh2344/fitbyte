import 'package:fitbyte/dashboard/calculation/calculation_controller.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaloriesCalculatorCard extends StatelessWidget {
  const CaloriesCalculatorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      return IntrinsicHeight(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_fire_department, color: themeController.theme.primaryColor, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Calorie Calculator',
                      style: themeController.theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (controller.calories.value > 0) ...[
                  Text(
                    'Your daily calorie needs: ${controller.calories.value.toStringAsFixed(0)} kcal',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on your ${controller.activityLevel.value.replaceAll('_', ' ')} activity',
                    style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fuel Your Gains!',
                    style: TextStyle(
                      fontSize: 14,
                      color: themeController.theme.primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'Calculate your calorie needs!',
                    style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter details to see your daily calorie needs!',
                    style: TextStyle(
                      fontSize: 14,
                      color: themeController.theme.primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _showInputDialog(context, controller, themeController),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Calculate Calories'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showInputDialog(BuildContext context, CalculatorController controller, ThemeController themeController) {
    final TextEditingController weightController = TextEditingController();
    final TextEditingController heightCmController = TextEditingController();
    final TextEditingController feetController = TextEditingController();
    final TextEditingController inchesController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    int currentPage = 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Enter Calorie Details - Page $currentPage',
                style: TextStyle(color: themeController.theme.primaryColor),
              ),
              content: SingleChildScrollView(
                child: Obx(() {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (currentPage == 1) ...[
                        TextField(
                          controller: weightController,
                          decoration: InputDecoration(
                            labelText: 'Weight (kg)',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.fitness_center, color: themeController.theme.primaryColor),
                            errorText: weightController.text.isNotEmpty &&
                                    (double.tryParse(weightController.text) ?? 0.0) <= 0
                                ? 'Enter a valid weight'
                                : null,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: controller.updateWeight,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: controller.heightUnit.value,
                          decoration: InputDecoration(
                            labelText: 'Height Unit',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                          ),
                          items: ['cm', 'ft/in'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value == 'cm' ? 'Centimeters' : 'Feet/Inches'),
                            );
                          }).toList(),
                          onChanged: controller.updateHeightUnit,
                        ),
                        const SizedBox(height: 8),
                        if (controller.heightUnit.value == 'cm')
                          TextField(
                            controller: heightCmController,
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                              border: const OutlineInputBorder(),
                              prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                              errorText: heightCmController.text.isNotEmpty &&
                                      (double.tryParse(heightCmController.text) ?? 0.0) <= 0
                                  ? 'Enter a valid height'
                                  : null,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: controller.updateHeight,
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: feetController,
                                  decoration: InputDecoration(
                                    labelText: 'Feet',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                                    errorText: feetController.text.isNotEmpty &&
                                            (int.tryParse(feetController.text) ?? 0) <= 0
                                        ? 'Enter valid feet'
                                        : null,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: controller.updateFeet,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: inchesController,
                                  decoration: InputDecoration(
                                    labelText: 'Inches',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                                    errorText: inchesController.text.isNotEmpty &&
                                            (double.tryParse(inchesController.text) ?? 0.0) < 0
                                        ? 'Enter valid inches'
                                        : null,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: controller.updateInches,
                                ),
                              ),
                            ],
                          ),
                       
                      ] else ...[
                         DropdownButtonFormField<String>(
                          value: controller.gender.value,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: themeController.theme.primaryColor),
                          ),
                          items: ['male', 'female'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: controller.updateGender,
                        ),
                        // if (controller.heightUnit.value == 'cm')
                        //   TextField(
                        //     controller: heightCmController,
                        //     decoration: InputDecoration(
                        //       labelText: 'Height (cm)',
                        //       border: const OutlineInputBorder(),
                        //       prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                        //       errorText: heightCmController.text.isNotEmpty &&
                        //               (double.tryParse(heightCmController.text) ?? 0.0) <= 0
                        //           ? 'Enter a valid height'
                        //           : null,
                        //     ),
                        //     keyboardType: TextInputType.number,
                        //     onChanged: controller.updateHeight,
                        //   )
                        // else
                        //   Row(
                        //     children: [
                        //       Expanded(
                        //         child: TextField(
                        //           controller: feetController,
                        //           decoration: InputDecoration(
                        //             labelText: 'Feet',
                        //             border: const OutlineInputBorder(),
                        //             prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                        //             errorText: feetController.text.isNotEmpty &&
                        //                     (int.tryParse(feetController.text) ?? 0) <= 0
                        //                 ? 'Enter valid feet'
                        //                 : null,
                        //           ),
                        //           keyboardType: TextInputType.number,
                        //           onChanged: controller.updateFeet,
                        //         ),
                        //       ),
                        //       const SizedBox(width: 8),
                        //       Expanded(
                        //         child: TextField(
                        //           controller: inchesController,
                        //           decoration: InputDecoration(
                        //             labelText: 'Inches',
                        //             border: const OutlineInputBorder(),
                        //             prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                        //             errorText: inchesController.text.isNotEmpty &&
                        //                     (double.tryParse(inchesController.text) ?? 0.0) < 0
                        //                 ? 'Enter valid inches'
                        //                 : null,
                        //           ),
                        //           keyboardType: TextInputType.number,
                        //           onChanged: controller.updateInches,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: ageController,
                          decoration: InputDecoration(
                            labelText: 'Age (years)',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.cake, color: themeController.theme.primaryColor),
                            errorText: ageController.text.isNotEmpty &&
                                    (int.tryParse(ageController.text) ?? 0) <= 0
                                ? 'Enter a valid age'
                                : null,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: controller.updateAge,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: controller.activityLevel.value,
                          decoration: InputDecoration(
                            labelText: 'Activity Level',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.directions_run, color: themeController.theme.primaryColor),
                          ),
                          items: [
                            'sedentary',
                            'lightly_active',
                            'moderately_active',
                            'very_active',
                            'extremely_active'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.replaceAll('_', ' ')),
                            );
                          }).toList(),
                          onChanged: controller.updateActivityLevel,
                        ),
                      ],
                    ],
                  );
                }),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                if (currentPage == 1)
                  ElevatedButton(
                    onPressed: () {
                      if (weightController.text.isNotEmpty &&
                          (double.tryParse(weightController.text) ?? 0.0) > 0) {
                        setState(() {
                          currentPage = 2;
                        });
                      } else {
                        Get.snackbar('Error', 'Please enter a valid weight',
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.theme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Next'),
                  ),
                if (currentPage == 2) ...[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        currentPage = 1;
                      });
                    },
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.weight.value > 0 &&
                          (controller.height.value > 0 || controller.feet.value > 0) &&
                          controller.age.value > 0) {
                        controller.calculate();
                        Navigator.pop(context);
                      } else {
                        Get.snackbar('Error', 'Please enter valid weight, height, and age',
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.theme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Calculate'),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}