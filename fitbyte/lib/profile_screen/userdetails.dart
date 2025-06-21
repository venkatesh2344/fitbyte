import 'package:fitbyte/dashboard/calculation/calculation_controller.dart';
import 'package:fitbyte/dashboard/dashboard_controller.dart';
import 'package:fitbyte/theme/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailsCard extends StatefulWidget {
  const UserDetailsCard({super.key});

  @override
  State<UserDetailsCard> createState() => _UserDetailsCardState();
}

class _UserDetailsCardState extends State<UserDetailsCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightCmController = TextEditingController();
  final _heightFtController = TextEditingController();
  final _heightInController = TextEditingController();
  bool _isEditing = false;
  String _gender = 'male';
  String _heightUnit = 'cm';
  String? _activityLevel = 'sedentary';
  double _height = 1.75;

  // Store the ever listener subscription to clean it up in dispose
  late final Worker _userSettingsListener;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<DashboardController>();
    _updateFormFields(controller.userSettings); // Initial setup

    // Listen for changes in userSettings
    _userSettingsListener = ever(controller.userSettings, (Map<dynamic, dynamic> settings) {
      if (!_isEditing && mounted) { // Check mounted to avoid setState after dispose
        setState(() {
          _updateFormFields(settings);
        });
      }
    });

    // Fetch settings on initialization (remove if called elsewhere)
    controller.fetchUserSettings();
  }

  void _updateFormFields(Map<dynamic, dynamic> settings) {
    _nameController.text = settings['name']?.toString() ?? '';
    _nicknameController.text = settings['nickname']?.toString() ?? '';
    _phoneController.text = settings['phone']?.toString() ?? '';
    _ageController.text = settings['age']?.toString() ?? '';
    final storedGender = settings['gender']?.toString().toLowerCase();
    _gender = ['male', 'female', 'other'].contains(storedGender) ? storedGender! : 'male';
    _height = (settings['height'] as num?)?.toDouble() ?? 1.75;
    _heightUnit = settings['height_unit']?.toString() ?? 'cm';
    _activityLevel = settings['activity_level']?.toString() ?? 'sedentary';
    if (_heightUnit == 'cm') {
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
    print('Updated form fields: name=${_nameController.text}, gender=$_gender, height=$_height');
  }

  @override
  void dispose() {
    // Clean up the ever listener
    _userSettingsListener.dispose();
    // Dispose controllers
    _nameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _heightCmController.dispose();
    _heightFtController.dispose();
    _heightInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final CalculatorController calcController = Get.find<CalculatorController>();

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Details',
                      style: themeController.theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isEditing ? Icons.cancel : Icons.edit,
                        size: 24,
                        color: themeController.theme.primaryColor,
                      ),
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            if (_isEditing) {
                              _updateFormFields(controller.userSettings);
                            }
                            _isEditing = !_isEditing;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_isEditing) ...[
                  _buildDetailRow(
                    label: 'Name',
                    value: controller.userSettings['name']?.toString() ?? 'Not set',
                    icon: Icons.person,
                  ),
                  _buildDetailRow(
                    label: 'Nickname',
                    value: controller.userSettings['nickname']?.toString() ?? 'Not set',
                    icon: Icons.badge,
                  ),
                  _buildDetailRow(
                    label: 'Phone',
                    value: controller.userSettings['phone']?.toString() ?? 'Not set',
                    icon: Icons.phone,
                  ),
                  _buildDetailRow(
                    label: 'Age',
                    value: controller.userSettings['age'] != null ? '${controller.userSettings['age']} years' : 'Not set',
                    icon: Icons.cake,
                  ),
                  _buildDetailRow(
                    label: 'Gender',
                    value: controller.userSettings['gender']?.toString() ?? 'Not set',
                    icon: Icons.person_outline,
                  ),
                  _buildDetailRow(
                    label: 'Height',
                    value: _formatHeight(
                      (controller.userSettings['height'] as num?)?.toDouble(),
                      controller.userSettings['height_unit']?.toString(),
                    ),
                    icon: Icons.height,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Activity Level',
                    style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  ChoiceChip(
                    label: Text(
                      (controller.userSettings['activity_level']?.toString() ?? 'sedentary').replaceAll('_', ' '),
                    ),
                    selected: true,
                    selectedColor: themeController.theme.primaryColor,
                    backgroundColor: Colors.white,
                    labelStyle: const TextStyle(color: Colors.white),
                    onSelected: (_) {},
                  ),
                ] else ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'e.g., John Doe',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: themeController.theme.primaryColor),
                          ),
                          validator: (value) => value?.trim().isEmpty ?? true ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nicknameController,
                          decoration: InputDecoration(
                            labelText: 'Nickname (Optional)',
                            hintText: 'e.g., Johnny',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge, color: themeController.theme.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: 'e.g., +1234567890',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone, color: themeController.theme.primaryColor),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value?.trim().isEmpty ?? true ? 'Enter your phone' : null,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline, color: themeController.theme.primaryColor),
                          ),
                          items: ['male', 'female', 'other']
                              .map((gender) => DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender[0].toUpperCase() + gender.substring(1)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null && mounted) {
                              setState(() {
                                _gender = value;
                                print('Gender changed to: $value');
                              });
                            }
                          },
                          validator: (value) => value == null ? 'Select a gender' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            hintText: 'e.g., 30',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.cake, color: themeController.theme.primaryColor),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.trim().isEmpty ?? true) return 'Enter your age';
                            final age = int.tryParse(value!.trim());
                            if (age == null || age <= 0 || age > 120) return 'Valid age (1–120)';
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _heightUnit,
                          decoration: InputDecoration(
                            labelText: 'Height Unit',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                          ),
                          items: ['cm', 'ft/in']
                              .map((unit) => DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit == 'cm' ? 'Centimeters' : 'Feet/Inches'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null && mounted) {
                              setState(() {
                                _heightUnit = value;
                                if (value == 'cm') {
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
                          validator: (value) => value == null ? 'Select a height unit' : null,
                        ),
                        const SizedBox(height: 8),
                        if (_heightUnit == 'cm')
                          TextFormField(
                            controller: _heightCmController,
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                              hintText: 'e.g., 175',
                              border: const OutlineInputBorder(),
                              prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) return 'Enter height';
                              final heightCm = double.tryParse(value!.trim());
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
                                child: TextFormField(
                                  controller: _heightFtController,
                                  decoration: InputDecoration(
                                    labelText: 'Feet',
                                    hintText: 'e.g., 5',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value?.trim().isEmpty ?? true) return 'Enter feet';
                                    final feet = int.tryParse(value!.trim());
                                    if (feet == null || feet < 3 || feet > 8) {
                                      return 'Valid feet (3–8)';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    final feet = int.tryParse(value) ?? 0;
                                    final inches = double.tryParse(_heightInController.text) ?? 0;
                                    if (feet >= 3 && feet <= 8) {
                                      _height = (feet + inches / 12) * 0.3048;
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _heightInController,
                                  decoration: InputDecoration(
                                    labelText: 'Inches',
                                    hintText: 'e.g., 9',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.height, color: themeController.theme.primaryColor),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value?.trim().isEmpty ?? true) return 'Enter inches';
                                    final inches = double.tryParse(value!.trim());
                                    if (inches == null || inches < 0 || inches >= 12) {
                                      return 'Valid inches (0–11)';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    final feet = int.tryParse(_heightFtController.text) ?? 0;
                                    final inches = double.tryParse(value) ?? 0;
                                    if (inches >= 0 && inches < 12 && feet >= 3 && feet <= 8) {
                                      _height = (feet + inches / 12) * 0.3048;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _activityLevel,
                          decoration: InputDecoration(
                            labelText: 'Activity Level',
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.directions_run, color: themeController.theme.primaryColor),
                          ),
                          items: [
                            'sedentary',
                            'lightly_active',
                            'moderately_active',
                            'very_active',
                            'extremely_active',
                          ].map((level) => DropdownMenuItem<String>(
                                value: level,
                                child: Text(level.replaceAll('_', ' ')),
                              )).toList(),
                          onChanged: (value) {
                            if (value != null && mounted) {
                              setState(() => _activityLevel = value);
                            }
                          },
                          validator: (value) => value == null ? 'Select activity level' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    _isEditing = false;
                                    _updateFormFields(controller.userSettings);
                                  });
                                }
                              },
                              child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.grey)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final age = int.parse(_ageController.text.trim());
                                    await Get.find<ThemeController>().setUserSettings(
                                      name: _nameController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      nickname: _nicknameController.text.trim(),
                                      age: age,
                                      gender: _gender,
                                      height: _height,
                                      activityLevel: _activityLevel!,
                                      heightUnit: _heightUnit,
                                    );
                                    controller.userSettings.assignAll({
                                      'name': _nameController.text.trim(),
                                      'phone': _phoneController.text.trim(),
                                      'nickname': _nameController.text.trim(),
                                      'age': age,
                                      'gender': _gender,
                                      'height': _height,
                                      'activity_level': _activityLevel,
                                      'height_unit': _heightUnit,
                                    });
                                    calcController.updateGender(_gender);
                                    calcController.updateHeightUnit(_heightUnit);
                                    calcController.updateAge(_ageController.text.trim());
                                    if (_heightUnit == 'cm') {
                                      calcController.updateHeight(_heightCmController.text.trim());
                                    } else {
                                      calcController.updateFeet(_heightFtController.text.trim());
                                      calcController.updateInches(_heightInController.text.trim());
                                    }
                                    calcController.calculate();
                                    if (mounted) {
                                      setState(() => _isEditing = false);
                                    }
                                    Get.snackbar(
                                      'Profile Updated!',
                                      'Your stats are ready to roll!',
                                      backgroundColor: themeController.theme.primaryColor,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                      icon: const Icon(Icons.fitness_center, color: Colors.white),
                                    );
                                  } catch (e) {
                                    Get.snackbar(
                                      'Error',
                                      'Failed to update profile: $e',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Please complete all required fields',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 12,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController.theme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                minimumSize: const Size(100, 40),
                              ),
                              child: const Text('Save', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Get.find<ThemeController>().theme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  String _formatHeight(double? heightMeters, String? heightUnit) {
    if (heightMeters == null || heightUnit == null) return 'Not set';
    if (heightUnit == 'cm') {
      return '${(heightMeters * 100).toStringAsFixed(0)} cm';
    } else {
      final feet = (heightMeters * 3.28084).floor();
      final inches = ((heightMeters * 39.3701) % 12).round();
      return '$feet ft $inches in';
    }
  }
}