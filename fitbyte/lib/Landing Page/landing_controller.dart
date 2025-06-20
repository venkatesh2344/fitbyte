import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LandingController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
