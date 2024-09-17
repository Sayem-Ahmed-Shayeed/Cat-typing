import 'package:cat_typing/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  Chart({
    super.key,
    required this.wpmList,
    required this.chosenTime,
    required this.mistakeTimes,
  });

  List<double> wpmList; // List to hold WPM data points
  int chosenTime;
  List<int> mistakeTimes; // List to hold mistake times in seconds

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 380,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: wpmList.isNotEmpty ? wpmList.reduce((a, b) => a > b ? a : b) : 10,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.5),
                strokeWidth: 0.5,
              );
            },
            
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.5),
                strokeWidth: 0.5,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (wpmList.isNotEmpty ? wpmList.reduce((a, b) => a > b ? a : b) / 5 : 2).toDouble(),
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: wpmList.length > 10 ? (wpmList.length / 10).toDouble() : 1,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              preventCurveOverShooting: true,
              show: true,
              barWidth: 0.5,
              spots: _getFlSpots(),
              isCurved: true,
              color:kColorScheme.primaryContainer.withOpacity(0.8), // Set the line color to purple
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, xPercentage, bar, index) {
                  if (mistakeTimes.contains(spot.x.toInt())) {
                    return FlDotCrossPainter(
                      size: 6, // Size of the cross
                      width: 1,
                      color: Colors.red, // Use red color to highlight mistakes
                    );
                  } else {
                    return FlDotCirclePainter(
                      radius: 2, // Increased size for visibility
                      color: Colors.white, // Regular dot color
                      strokeWidth: 0.5,
                      strokeColor: Colors.white,
                    );
                  }
                },
              ),
              belowBarData: BarAreaData(show: true, color: const Color.fromARGB(85, 233, 30, 98).withOpacity(0.1)),
            ),
          ],
          lineTouchData: const LineTouchData(
            touchTooltipData: LineTouchTooltipData(
            ),
            touchSpotThreshold: 8,
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getFlSpots() {
    return List.generate(
      wpmList.length,
      (index) => FlSpot(
        (index + 1).toDouble(), wpmList[index], // X-axis: time in seconds
      ),
    );
  }
}
