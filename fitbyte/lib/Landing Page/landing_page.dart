import 'package:fitbyte/Landing%20Page/landing_controller.dart';
import 'package:fitbyte/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final LandingController controller = Get.put(LandingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4, // 4/6 of the screen
            child: Container(
              color: Theme.of(context).colorScheme.secondary, // Fallback to secondary color (blue)
              child: Image.asset(
                'assets/landing_image.jpg', // Replace with your image path
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.secondary, // Blue if image fails
                    child: const Center(child: Text('Image not found')),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2, // Remaining 2/6 of the screen
            child: Container(
              color:  Colors.pink[100],
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: PageView(
                        controller: controller.pageController,
                        onPageChanged: (index) {
                          controller.currentPage.value = index;
                        },
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Welcome to FitByte\nStart your fitness journey with us by tracking your weight, calories, and BMI. Get personalized insights to achieve your goals!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Track your progress\nLog your daily meals and workouts to see how your body transforms over time with FitByte’s powerful tools!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Join the community\nConnect with other fitness enthusiasts and share your journey with FitByte’s social features!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.currentPage.value == index ? Colors.white : Colors.white54,
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.currentPage.value < 2) {
                            controller.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          } else {
                            Get.to(() => OnboardingScreen());
                          }
                        },
                        child: Text(controller.currentPage.value < 2 ? 'Next' : 'Get Started'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}