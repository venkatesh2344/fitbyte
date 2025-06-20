import 'package:fitbyte/dashboard/calculation/calculation_controller.dart';
import 'package:fitbyte/dashboard/dashboard_controller.dart';
import 'package:fitbyte/profile_screen/clear.dart';
import 'package:fitbyte/profile_screen/fitness_status.dart';
import 'package:fitbyte/profile_screen/userdetails.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Defer CalculatorController updates to avoid build-phase changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<DashboardController>();
      final calcController = Get.find<CalculatorController>();
      calcController.weight.value = controller.latestWeight.value;
      calcController.height.value = controller.userSettings['height'] ?? 1.75;
      calcController.age.value = controller.userSettings['age'] ?? 0;
      calcController.gender.value = controller.userSettings['gender']?.toLowerCase() ?? 'male';
      calcController.activityLevel.value = controller.userSettings['activity_level'] ?? 'sedentary';
      calcController.heightUnit.value = controller.userSettings['height_unit'] ?? 'cm';
      calcController.calculate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Gym Profile',
          style: themeController.theme.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: themeController.theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [themeController.theme.primaryColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Motivational Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Icon(Icons.fitness_center, size: 50, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        'Keep Crushing It!',
                        style: themeController.theme.textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Your fitness journey stats',
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // User Details Card
                const UserDetailsCard(),
                const SizedBox(height: 16),
                // Fitness Stats Card
                const FitnessStatsCard(),
                const SizedBox(height: 16),
                // Clear Data Button
                const ClearDataButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}