import 'package:fitbyte/Landing%20Page/landing_page.dart';
import 'package:fitbyte/dashboard/dashboard_controller.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:fitbyte/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClearDataButton extends StatefulWidget {
  const ClearDataButton({super.key});

  @override
  _ClearDataButtonState createState() => _ClearDataButtonState();
}

class _ClearDataButtonState extends State<ClearDataButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _shadowAnimation = Tween<double>(begin: 4.0, end: 8.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return MouseRegion(
      onEnter: (_) => _animationController.forward(),
      onExit: (_) => _animationController.reverse(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: _shadowAnimation.value,
              offset: Offset(0, _shadowAnimation.value / 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _showClearDataDialog(context, controller),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size(double.infinity, 40),
          ),
          child: const Text(
            'Clear All Data',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, DashboardController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Clear All Data',
            style: Get.find<ThemeController>().theme.textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: const Text(
            'Are you sure you want to clear all user settings and weight records? This action cannot be undone.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await DatabaseHelper.instance.clearAllData();
                  // controller.userSettings.clear();
                  // controller.latestWeight.value = 0.0;
                  Navigator.pop(context);
                  Get.snackbar(
                    'Success',
                    'All data cleared successfully',
                    backgroundColor: Get.find<ThemeController>().theme.primaryColor,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    icon: const Icon(Icons.fitness_center, color: Colors.white),
                  );
                  Get.offAll(() =>LandingPage());
                } catch (e) {
                  Navigator.pop(context);
                  Get.snackbar(
                    'Error',
                    'Failed to clear data: $e',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Clear', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}