import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../dashboard_controller.dart';

class WeightRecordsPage extends StatelessWidget {
  const WeightRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weight Records',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Theme.of(context).primaryColor, Colors.white],
          ),
        ),
        child: Obx(() {
          // Create a copy of records with parsed DateTime
          final records = controller.weightRecords
              .map((record) {
                try {
                  return {
                    'weight': record['weight'] as double,
                    'date': DateTime.parse(record['date'] as String),
                  };
                } catch (e) {
                  // Handle invalid date formats gracefully
                  return {
                    'weight': record['weight'] as double,
                    'date': DateTime(2000), // Fallback date for sorting
                  };
                }
              })
              .toList()
            ..sort((a, b) {
              final dateA = a['date'] as DateTime;
              final dateB = b['date'] as DateTime;
              return dateB.compareTo(dateA); // Latest first
            });

          if (records.isEmpty) {
            return Center(
              child: Text(
                'No weight records found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final weight = record['weight'] as double;
              final date = record['date'] as DateTime;
              final formattedDate = DateFormat('MMMM dd, yyyy').format(date);

              // Calculate weight change with the previous record (earlier date)
              double? weightChange;
              if (index < records.length - 1) {
                final prevWeight = records[index + 1]['weight'] as double;
                weightChange = weight - prevWeight;
              }

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    '${weight.toStringAsFixed(1)} kg',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      if (weightChange != null)
                        Text(
                          'Change: ${weightChange >= 0 ? '+' : ''}${weightChange.toStringAsFixed(2)} kg',
                          style: TextStyle(
                            fontSize: 14,
                            color: weightChange >= 0 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}