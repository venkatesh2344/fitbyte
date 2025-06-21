import 'package:fitbyte/dashboard/bmi_calory_card/bmi_calory_card.dart';
import 'package:fitbyte/dashboard/bmi_calory_card/calory_cal.dart';
import 'package:fitbyte/dashboard/dashboard_bottom.dart';
import 'package:fitbyte/dashboard/dashboard_controller.dart';
import 'package:fitbyte/dashboard/dashboard_header.dart';
import 'package:fitbyte/dashboard/weight/weight_progresscard.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      body: Obx(() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [themeController.theme.primaryColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              DashboardHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: SizedBox(
                              height: 300, // Constrain WeightProgressCard height
                              width: double.infinity,
                              child: WeightProgressCard(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: const BMICalculatorCard(),
                          ),
                          const SizedBox(height: 16),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: const CaloriesCalculatorCard(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: DashboardBottomNav(),
    );
  }
}