import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WeightGraph extends StatelessWidget {
  final List<Map<String, dynamic>> records;

  const WeightGraph({required this.records});

  @override
  Widget build(BuildContext context) {
    final weights = records.map((r) => r['weight'] as double).toList();
    final minWeight = weights.isNotEmpty ? weights.reduce((a, b) => a < b ? a : b) - 5 : 0.0;
    final maxWeight = weights.isNotEmpty ? weights.reduce((a, b) => a > b ? a : b) + 5 : 100.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: records.length - 1 < 0 ? 0 : records.length - 1,
        minY: minWeight,
        maxY: maxWeight,
        lineBarsData: [
          LineChartBarData(
            spots: records
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value['weight'] as double))
                .toList(),
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: Theme.of(context).primaryColor,
                strokeWidth: 1,
                strokeColor: Colors.white,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final record = records[spot.x.toInt()];
                final weight = record['weight'] as double;
                final date = DateTime.parse(record['date']);
                final formattedDate = DateFormat('MMM dd, yyyy').format(date);

                return LineTooltipItem(
                  '$formattedDate\n$weight kg',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
            // tooltipBgColor: Theme.of(context).primaryColor.withOpacity(0.9),
            tooltipPadding: EdgeInsets.all(8),
            tooltipMargin: 10,
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }
}