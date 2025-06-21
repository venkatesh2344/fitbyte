import 'package:fitbyte/dashboard/calculation/calculation_controller.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMICalculatorCard extends StatelessWidget {
  const BMICalculatorCard({super.key});

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
                    Icon(Icons.health_and_safety, color: themeController.theme.primaryColor, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'BMI Calculator',
                      style: themeController.theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: controller.bmi.value > 0
                      ? SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 10,
                              maximum: 40,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: 10,
                                  endValue: 18.5,
                                  color: Colors.blue[200],
                                  label: 'Underweight',
                                  labelStyle: const GaugeTextStyle(fontSize: 10),
                                  sizeUnit: GaugeSizeUnit.factor,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                ),
                                GaugeRange(
                                  startValue: 18.5,
                                  endValue: 24.9,
                                  color: Colors.green.withOpacity(0.7),
                                  label: 'Normal',
                                  labelStyle: const GaugeTextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  sizeUnit: GaugeSizeUnit.factor,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                ),
                                GaugeRange(
                                  startValue: 24.9,
                                  endValue: 29.9,
                                  color: Colors.orange,
                                  label: 'Overweight',
                                  labelStyle: const GaugeTextStyle(fontSize: 10),
                                  sizeUnit: GaugeSizeUnit.factor,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                ),
                                GaugeRange(
                                  startValue: 29.9,
                                  endValue: 40,
                                  color: Colors.red,
                                  label: 'Obese',
                                  labelStyle: const GaugeTextStyle(fontSize: 10),
                                  sizeUnit: GaugeSizeUnit.factor,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                ),
                              ],
                              pointers: [
                                NeedlePointer(
                                  value: controller.bmi.value,
                                  enableAnimation: true,
                                  animationType: AnimationType.ease,
                                  needleColor: themeController.theme.primaryColor,
                                ),
                              ],
                              annotations: [
                                GaugeAnnotation(
                                  widget: Text(
                                    controller.bmi.value.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.5,
                                ),
                              ],
                              labelOffset: 15,
                              axisLabelStyle: const GaugeTextStyle(fontSize: 10),
                              showTicks: true,
                              showLabels: true,
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            'Calculate your BMI to see the gauge!',
                            style: TextStyle(
                              fontSize: 16,
                              color: themeController.theme.primaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.bmi.value > 0 ? 'Status: ${controller.bmiStatus.value}' : 'Typical BMI Ranges',
                  style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.bmi.value > 0 ? 'Stay on Track!' : 'Calculate your BMI to see your status!',
                  style: TextStyle(
                    fontSize: 14,
                    color: themeController.theme.primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _showInputDialog(context, controller, themeController),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Calculate BMI'),
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
    showDialog(
      context: context,
      builder: (context) => _BMIDialog(
        controller: controller,
        themeController: themeController,
      ),
    );
  }
}

class _BMIDialog extends StatefulWidget {
  final CalculatorController controller;
  final ThemeController themeController;

  const _BMIDialog({
    required this.controller,
    required this.themeController,
  });

  @override
  _BMIDialogState createState() => _BMIDialogState();
}

class _BMIDialogState extends State<_BMIDialog> {
  late final TextEditingController weightController;
  late final TextEditingController heightCmController;
  late final TextEditingController feetController;
  late final TextEditingController inchesController;
  late String heightUnit;

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController();
    heightCmController = TextEditingController();
    feetController = TextEditingController();
    inchesController = TextEditingController();
    heightUnit = widget.controller.heightUnit.value;

  //   // Initialize controllers with current values
  //   if (widget.controller.weight.value > 0) {
  //     weightController.text = widget.controller.weight.value.toString();
  //   }
  //   if (widget.controller.height.value > 0 && heightUnit == 'cm') {
  //     heightCmController.text = widget.controller.height.value.toString();
  //   }
  //   if (widget.controller.feet.value > 0 && heightUnit == 'ft/in') {
  //     feetController.text = widget.controller.feet.value.toString();
  //   }
  //   if (widget.controller.inches.value > 0 && heightUnit == 'ft/in') {
  //     inchesController.text = widget.controller.inches.value.toString();
  //   }
  }

  @override
  void dispose() {
    weightController.dispose();
    heightCmController.dispose();
    feetController.dispose();
    inchesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter BMI Details',
        style: TextStyle(color: widget.themeController.theme.primaryColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center, color: widget.themeController.theme.primaryColor),
                errorText: weightController.text.isNotEmpty &&
                        (double.tryParse(weightController.text) ?? 0.0) <= 0
                    ? 'Enter a valid weight'
                    : null,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                widget.controller.updateWeight(value);
                if (mounted) setState(() {}); // Update error text
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: heightUnit,
              decoration: InputDecoration(
                labelText: 'Height Unit',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.height, color: widget.themeController.theme.primaryColor),
              ),
              items: ['cm', 'ft/in'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'cm' ? 'Centimeters' : 'Feet/Inches'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null && mounted) {
                  setState(() {
                    heightUnit = value;
                    widget.controller.updateHeightUnit(value);
                    // Clear fields when unit changes
                    heightCmController.clear();
                    feetController.clear();
                    inchesController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            if (heightUnit == 'cm')
              TextField(
                controller: heightCmController,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height, color: widget.themeController.theme.primaryColor),
                  errorText: heightCmController.text.isNotEmpty &&
                          (double.tryParse(heightCmController.text) ?? 0.0) <= 0
                      ? 'Enter a valid height'
                      : null,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  widget.controller.updateHeight(value);
                  if (mounted) setState(() {}); // Update error text
                },
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
                        prefixIcon: Icon(Icons.height, color: widget.themeController.theme.primaryColor),
                        errorText: feetController.text.isNotEmpty &&
                                (int.tryParse(feetController.text) ?? 0) <= 0
                            ? 'Enter valid feet'
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        widget.controller.updateFeet(value);
                        if (mounted) setState(() {}); // Update error text
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: inchesController,
                      decoration: InputDecoration(
                        labelText: 'Inches',
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(Icons.height, color: widget.themeController.theme.primaryColor),
                        errorText: inchesController.text.isNotEmpty &&
                                (double.tryParse(inchesController.text) ?? 0.0) < 0
                            ? 'Enter valid inches'
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        widget.controller.updateInches(value);
                        if (mounted) setState(() {}); // Update error text
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if ((widget.controller.weight.value > 0) &&
                (widget.controller.height.value > 0 || (widget.controller.feet.value > 0))) {
              widget.controller.calculate();
              Navigator.pop(context);
            } else {
              Get.snackbar('Error', 'Please enter valid weight and height',
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.themeController.theme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Calculate'),
        ),
      ],
    );
  }
}