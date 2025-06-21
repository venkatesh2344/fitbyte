import 'package:fitbyte/dashboard/calculation/calculation_controller.dart';
import 'package:fitbyte/dashboard/dashboard_controller.dart';
import 'package:fitbyte/splashscreen.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbyte/utils/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseHelper = DatabaseHelper.instance;
  await databaseHelper.database; // Ensure database is ready
  Get.put(ThemeController());
  Get.put(DashboardController());
  Get.put(CalculatorController());
  runApp(const FitByteApp());
}

class FitByteApp extends StatelessWidget {
  const FitByteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'FitByte',
        theme: themeController.theme,
        home: SplashScreen(),
      ),
    );
  }
}
