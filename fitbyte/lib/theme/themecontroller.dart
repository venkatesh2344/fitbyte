import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbyte/utils/database_helper.dart';

class ThemeController extends GetxController {
  RxString gender = 'male'.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      final settings = await DatabaseHelper.instance.getUserSettings();
      if (settings != null && settings['gender'] != null) {
        gender.value = settings['gender'];
      }
    } catch (e) {
      print('Error loading gender: $e');
    }
  }

  ThemeData get theme => ThemeData(
        primaryColor: gender.value == 'female' ? Colors.pink[100] : Colors.blue[100],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: gender.value == 'female' ? Colors.pink[100] : Colors.blue[100],
          secondary: gender.value == 'female' ? Colors.pink[200] : Colors.blue[200],
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gender.value == 'female' ? Colors.pink[200] : Colors.blue[200],
            foregroundColor: Colors.white,
          ),
        ),
      );

  Future<void> setUserSettings({
    required String name,
    required String phone,
    required String nickname,
    required int age,
    required String gender,
    required double height,
    required String activityLevel, 
        required String heightUnit,

  }) async {
    try {
      this.gender.value = gender;
      await DatabaseHelper.instance.setUserSettings(
        name: name,
        phone: phone,
        nickname: nickname,
        age: age,
        gender: gender,
        height: height,
        activityLevel: activityLevel,
              heightUnit: heightUnit,

      );
      Get.changeTheme(theme); // Update theme dynamically
    } catch (e) {
      print('Error saving user settings: $e');
    }
  }
}