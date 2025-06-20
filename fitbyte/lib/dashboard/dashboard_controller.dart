import 'package:get/get.dart';
import 'package:fitbyte/utils/database_helper.dart';

class DashboardController extends GetxController {
  var userSettings = {}.obs;
  var weightRecords = <Map<String, dynamic>>[].obs;
  var latestWeight = RxDouble(0.0);

  @override
  void onInit() {
    super.onInit();
    fetchUserSettings();
    fetchWeightRecords();
  }

  Future<void> fetchUserSettings() async {
    final settings = await DatabaseHelper.instance.getUserSettings();
    if (settings != null) {
      userSettings.value = settings;
    }
  }

  Future<void> fetchWeightRecords() async {
    final records = await DatabaseHelper.instance.getWeightRecords();
    weightRecords.value = records;
    if (records.isNotEmpty) {
      latestWeight.value = records.last['weight'] as double;
    }
  }

  Future<void> addWeight(double weight, String date) async {
    await DatabaseHelper.instance.insertWeightRecord(weight, date);
    await fetchWeightRecords(); // Refresh records
  }
}