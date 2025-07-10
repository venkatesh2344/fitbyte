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
        primaryColor: gender.value == 'female' ? const Color(0xFFFF6B6B) : const Color(0xFF26A69A),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: gender.value == 'female' ? const Color(0xFFFF6B6B) : const Color(0xFF26A69A),
          secondary: gender.value == 'female' ? const Color(0xFFFF8787) : const Color(0xFF4DB6AC),
          surface: const Color(0xFFFAFAFA),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF212121),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF212121)),
          titleLarge: TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.w600,
          ),
          bodySmall: TextStyle(color: Color(0xFF757575)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gender.value == 'female' ? const Color(0xFFFF8787) : const Color(0xFF4DB6AC),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        iconTheme: IconThemeData(
          color: gender.value == 'female' ? const Color(0xFFFF6B6B) : const Color(0xFF26A69A),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFFFAFAFA),
          selectedItemColor: gender.value == 'female' ? const Color(0xFFFF6B6B) : const Color(0xFF26A69A),
          unselectedItemColor: const Color(0xFF757575),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: gender.value == 'female' ? const Color(0xFFFF6B6B) : const Color(0xFF26A69A),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: const TextStyle(color: Color(0xFF757575)),
          prefixIconColor: gender.value == 'female' ? const Color(0xFFFF6B6B) : const Color(0xFF26A69A),
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