import 'package:fitbyte/theme/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbyte/utils/database_helper.dart';
import 'package:fitbyte/dashboard/dashboard.dart';


class OnboardingScreen extends StatefulWidget {
  final Map<String, dynamic>? initialSettings;
  const OnboardingScreen({super.key, this.initialSettings});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightCmController = TextEditingController();
  final _heightFtController = TextEditingController();
  final _heightInController = TextEditingController();
  int _currentStep = 0;
  String _gender = 'Male';
  double _height = 1.75;
  String? _activityLevel = 'sedentary';
  bool _isSaving = false;
  String _heightUnit = 'cm';
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  final ThemeController _themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_animationController);

    if (widget.initialSettings != null) {
      _nameController.text = widget.initialSettings!['name'] ?? '';
      _phoneController.text = widget.initialSettings!['phone'] ?? '';
      _nicknameController.text = widget.initialSettings!['nickname'] ?? '';
      _ageController.text = widget.initialSettings!['age']?.toString() ?? '';
      _gender = widget.initialSettings!['gender'] ?? 'Male';
      _height = widget.initialSettings!['height'] ?? 1.75;
      _activityLevel = widget.initialSettings!['activity_level'] ?? 'sedentary';
      _heightUnit = widget.initialSettings!['height_unit'] ?? 'cm';
      if (_heightUnit == 'cm') {
        _heightCmController.text = (_height * 100).round().toString();
      } else {
        final feet = (_height * 3.28084).floor();
        final inches = ((_height * 39.3701) % 12).round();
        _heightFtController.text = feet.toString();
        _heightInController.text = inches.toString();
      }
    } else {
      _heightCmController.text = '175';
      _heightFtController.text = '5';
      _heightInController.text = '9';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nicknameController.dispose();
    _ageController.dispose();
    _heightCmController.dispose();
    _heightFtController.dispose();
    _heightInController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_themeController.theme.primaryColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    child: Column(
                      children: [
                        Icon(Icons.fitness_center, size: 60, color: Colors.white),
                        SizedBox(height: 12),
                        Text(
                          widget.initialSettings == null ? 'Your Fitness Starts Here!' : 'Update Your Stats!',
                          style: _themeController.theme.textTheme.titleLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => _buildStepDot(index)),
                  ),
                  SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _buildStepContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildStepDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      width: _currentStep == index ? 12 : 8,
      height: _currentStep == index ? 12 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentStep == index ? Colors.white : Colors.white54,
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildPhysicalStatsStep();
      case 2:
        return _buildActivityLevelStep();
      default:
        return Container();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      key: ValueKey('step0'),
      child: Column(
        children: [
          Text(
            'Who Are You?',
            style: _themeController.theme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          _buildAnimatedField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'e.g., John Doe',
            icon: Icons.person,
            validator: (value) => value!.isEmpty ? 'Enter your name' : null,
          ),
          SizedBox(height: 16),
          _buildAnimatedField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: 'e.g., +1234567890',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) => value!.isEmpty ? 'Enter your phone' : null,
          ),
          SizedBox(height: 16),
          _buildAnimatedField(
            controller: _nicknameController,
            label: 'Nickname (Optional)',
            hint: 'e.g., Johnny',
            icon: Icons.badge,
          ),
          SizedBox(height: 24),
          _buildNextButton(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPhysicalStatsStep() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      key: ValueKey('step1'),
      child: Column(
        children: [
          Text(
            'Your Body Stats',
            style: _themeController.theme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          _buildAnimatedField(
            controller: _ageController,
            label: 'Age',
            hint: 'e.g., 30',
            icon: Icons.cake,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'Enter your age';
              final age = int.tryParse(value);
              if (age == null || age <= 0 || age > 120) return 'Valid age (1–120)';
              return null;
            },
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Height Unit',
                    style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['cm', 'ft/in'].map((unit) => ChoiceChip(
                          label: Text(unit),
                          selected: _heightUnit == unit,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _heightUnit = unit;
                                if (unit == 'cm') {
                                  _heightCmController.text = (_height * 100).round().toString();
                                  _heightFtController.clear();
                                  _heightInController.clear();
                                } else {
                                  final feet = (_height * 3.28084).floor();
                                  final inches = ((_height * 39.3701) % 12).round();
                                  _heightFtController.text = feet.toString();
                                  _heightInController.text = inches.toString();
                                  _heightCmController.clear();
                                }
                              });
                            }
                          },
                          selectedColor: _themeController.theme.primaryColor,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: _heightUnit == unit ? Colors.white : Colors.black87,
                          ),
                        )).toList(),
                  ),
                  SizedBox(height: 16),
                  if (_heightUnit == 'cm')
                    _buildAnimatedField(
                      controller: _heightCmController,
                      label: 'Height (cm)',
                      hint: 'e.g., 175',
                      icon: Icons.height,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return 'Enter your height';
                        final heightCm = double.tryParse(value);
                        if (heightCm == null || heightCm < 100 || heightCm > 250) {
                          return 'Valid height (100–250 cm)';
                        }
                        _height = heightCm / 100;
                        return null;
                      },
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _buildAnimatedField(
                            controller: _heightFtController,
                            label: 'Feet',
                            hint: 'e.g., 5',
                            icon: Icons.height,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) return 'Enter feet';
                              final feet = int.tryParse(value);
                              if (feet == null || feet < 3 || feet > 8) return 'Valid feet (3–8)';
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildAnimatedField(
                            controller: _heightInController,
                            label: 'Inches',
                            hint: 'e.g., 9',
                            icon: Icons.height,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) return 'Enter inches';
                              final inches = int.tryParse(value);
                              if (inches == null || inches < 0 || inches >= 12) return 'Valid inches (0–11)';
                              final feet = int.tryParse(_heightFtController.text) ?? 0;
                              _height = (feet + inches / 12) * 0.3048;
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Gender',
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Male', 'Female', 'Other'].map((gender) => ChoiceChip(
                  label: Text(gender),
                  selected: _gender == gender,
                  onSelected: (selected) {
                    if (selected) setState(() => _gender = gender);
                  },
                  selectedColor: _themeController.theme.primaryColor,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: _gender == gender ? Colors.white : Colors.black87,
                  ),
                )).toList(),
          ),
          SizedBox(height: 24),
          _buildNextButton(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActivityLevelStep() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      key: ValueKey('step2'),
      child: Column(
        children: [
          Text(
            'How Active Are You?',
            style: _themeController.theme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This helps us calculate your calorie needs!',
            style: TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'sedentary',
              'lightly_active',
              'moderately_active',
              'very_active',
              'extremely_active'
            ].map((level) => ChoiceChip(
                  label: Text(level.replaceAll('_', ' ')),
                  selected: _activityLevel == level,
                  onSelected: (selected) {
                    if (selected) setState(() => _activityLevel = level);
                  },
                  selectedColor: _themeController.theme.primaryColor,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: _activityLevel == level ? Colors.white : Colors.black87,
                  ),
                )).toList(),
          ),
          SizedBox(height: 24),
          _buildFinishButton(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAnimatedField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 500),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: _themeController.theme.primaryColor),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          keyboardType: keyboardType,
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() => _currentStep++);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _themeController.theme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          minimumSize: Size(200, 50),
        ),
        child: Text(
          'Next',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: ElevatedButton(
        onPressed: _isSaving
            ? null
            : () async {
                if (_formKey.currentState!.validate() && _activityLevel != null) {
                  setState(() => _isSaving = true);
                  try {
                    await _themeController.setUserSettings(
                      name: _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                      nickname: _nicknameController.text.trim(),
                      age: int.parse(_ageController.text.trim()),
                      gender: _gender.toLowerCase(),
                      height: _height,
                      activityLevel: _activityLevel!,
                      heightUnit: _heightUnit,
                    );
                    Get.snackbar(
                      'You’re In!',
                      'Ready to smash your goals!',
                      backgroundColor: _themeController.theme.primaryColor,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: Duration(seconds: 3),
                      icon: Icon(Icons.fitness_center, color: Colors.white),
                    );
                    Get.offAll(() => DashboardPage());
                  } catch (e) {
                    print('Error saving user settings: $e');
                    Get.snackbar(
                      'Oops!',
                      'Something went wrong: $e',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: Duration(seconds: 3),
                    );
                  } finally {
                    setState(() => _isSaving = false);
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: _themeController.theme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          minimumSize: Size(200, 50),
        ),
        child: _isSaving
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                'Start My Journey!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}