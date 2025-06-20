import 'package:get/get.dart';

class CalculatorController extends GetxController {
  // Reactive inputs
  final RxDouble weight = 0.0.obs;
  final RxDouble height = 0.0.obs; // Height in meters (converted internally)
  final RxInt age = 0.obs;
  final RxString gender = 'male'.obs;
  final RxString activityLevel = 'sedentary'.obs;
  final RxString heightUnit = 'cm'.obs; // cm or ft/in
  final RxInt feet = 0.obs;
  final RxDouble inches = 0.0.obs;

  // Reactive results
  final RxDouble bmi = 0.0.obs;
  final RxDouble calories = 0.0.obs;
  final RxString bmiStatus = 'Unknown'.obs;

  void updateWeight(String value) {
    weight.value = double.tryParse(value) ?? 0.0;
  }

  void updateHeight(String value) {
    if (heightUnit.value == 'cm') {
      height.value = (double.tryParse(value) ?? 0.0) / 100; // Convert cm to m
    }
  }

  void updateFeet(String value) {
    feet.value = int.tryParse(value) ?? 0;
  }

  void updateInches(String value) {
    inches.value = double.tryParse(value) ?? 0.0;
  }

  void updateHeightUnit(String? value) {
    if (value != null) {
      heightUnit.value = value;
      // Reset height when unit changes
      height.value = 0.0;
      feet.value = 0;
      inches.value = 0.0;
    }
  }

  void updateAge(String value) {
    age.value = int.tryParse(value) ?? 0;
  }

  void updateGender(String? value) {
    if (value != null) gender.value = value;
  }

  void updateActivityLevel(String? value) {
    if (value != null) activityLevel.value = value;
  }

  void calculate() {
    // Convert height to meters if in ft/in
    if (heightUnit.value == 'ft/in') {
      height.value = (feet.value * 30.48 + inches.value * 2.54) / 100; // ft/in to m
    }

    // Calculate BMI
    if (weight.value > 0 && height.value > 0) {
      bmi.value = weight.value / (height.value * height.value);
      bmiStatus.value = _getBMIStatus(bmi.value);
    } else {
      bmi.value = 0.0;
      bmiStatus.value = 'Unknown';
    }

    // Calculate Calories
    if (weight.value > 0 && height.value > 0 && age.value > 0) {
      calories.value = _calculateCalories(
        age.value,
        gender.value,
        height.value,
        weight.value,
        activityLevel.value,
      ) ?? 0.0;
    } else {
      calories.value = 0.0;
    }
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal';
    if (bmi < 29.9) return 'Overweight';
    return 'Obese';
  }

  double? _calculateCalories(int age, String gender, double heightMeters, double weight, String activityLevel) {
    double bmr;
    final heightCm = heightMeters * 100;
    if (gender.toLowerCase() == 'male') {
      bmr = 10 * weight + 6.25 * heightCm - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * heightCm - 5 * age - 161;
    }
    switch (activityLevel) {
      case 'sedentary':
        return bmr * 1.2;
      case 'lightly_active':
        return bmr * 1.375;
      case 'moderately_active':
        return bmr * 1.55;
      case 'very_active':
        return bmr * 1.725;
      case 'extremely_active':
        return bmr * 1.9;
      default:
        return bmr * 1.2;
    }
  }
}