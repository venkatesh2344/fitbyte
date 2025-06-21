import 'package:fitbyte/Landing%20Page/landing_page.dart';
import 'package:fitbyte/dashboard/dashboard.dart';
import 'package:fitbyte/onboarding/onboarding.dart';
import 'package:fitbyte/utils/database_helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<Widget> _checkUserSettings() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final userSettings = await dbHelper.getUserSettings();
      if (userSettings != null) {
        return DashboardPage();
      } else {
        return LandingPage();
      }
    } catch (e) {
      print('Error checking user settings: $e');
      return LandingPage(); // Fallback to setup screen on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _checkUserSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error loading app',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        } else {
          return snapshot.data ?? LandingPage(); // Default to SetupScreen
        }
      },
    );
  }
}