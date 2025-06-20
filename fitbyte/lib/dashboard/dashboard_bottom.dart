import 'package:fitbyte/home/home.dart';
import 'package:fitbyte/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/dashboard.png',
            width: 24,
            height: 24,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/report.png',
            width: 24,
            height: 24,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Workouts',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/user.png',
            width: 24,
            height: 24,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 1) {
          Get.to(() => HomePage()); // Navigate to workouts page
        } else if (index == 2) {
          Get.snackbar('Profile', 'Profile page not implemented yet');
                    Get.to(() => ProfileScreen());

        }
      },
    );
  }
}