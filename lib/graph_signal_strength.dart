import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifi_analyzer/constants/network.dart';
import 'package:wifi_analyzer/dot_painter.dart';
import 'package:wifi_scan/wifi_scan.dart';

class GraphSignalStrength extends StatelessWidget {
  const GraphSignalStrength(
      {super.key,
      this.startShowFrequency = 2400,
      this.endShowFrequency = 2477,

      //TODO for colorblind
      this.colors = const [
        Colors.blue,
        Colors.red,
        Colors.yellow,
        Colors.brown,
        Colors.cyan,
        Colors.green,
        Colors.grey,
        Colors.orange,
        Colors.pink,
        Colors.purple,
        Colors.lime,
        Colors.teal,
        Colors.indigo
      ]});

  static const double minStrength = -100;
  static const double maxStrength = -30;
  final int startShowFrequency;
  final int endShowFrequency;

  final List<Color> colors;

  List<LineChartBarData> getSignals(List<WiFiAccessPoint> accessPoints) {
    final List<LineChartBarData> signals = [];
    for (final accesPoint in accessPoints) {
      final strength = accesPoint.level.toDouble();
      late int wifiFrequencyWidth;
      switch (accesPoint.channelWidth) {
        case WiFiChannelWidth.mhz20:
          wifiFrequencyWidth = 20;
          break;
        case WiFiChannelWidth.mhz40:
          wifiFrequencyWidth = 40;
          break;
        case WiFiChannelWidth.mhz80:
          wifiFrequencyWidth = 80;
          break;
        case WiFiChannelWidth.mhz160:
          wifiFrequencyWidth = 160;
          break;
        case WiFiChannelWidth.mhz80Plus80:
          wifiFrequencyWidth = 160;
          break;
        default:
      }

      final wifiFrequency = accesPoint.frequency;

      final random = Random();
      final color = colors[random.nextInt(colors.length)];

      signals.add(LineChartBarData(
        showingIndicators: [1],
        color: color,
        dotData: FlDotData(
          checkToShowDot: (spot, barData) => spot.x == wifiFrequency,
          getDotPainter: (p0, p1, p2, p3) =>
              MyFLPainter(ssid: accesPoint.ssid, color: color),
        ),
        spots: [
          FlSpot(wifiFrequency - wifiFrequencyWidth / 2,
              GraphSignalStrength.minStrength),
          FlSpot(wifiFrequency.toDouble(), strength),
          FlSpot(wifiFrequency + wifiFrequencyWidth / 2,
              GraphSignalStrength.minStrength)
        ],
        isCurved: true,
        isStrokeCapRound: true,
        barWidth: 1,
        belowBarData: BarAreaData(show: true, color: color.withOpacity(0.2)),
      ));
    }
    return signals;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WiFiAccessPoint>>(
        stream: WiFiScan.instance.onScannedResultsAvailable,
        builder: (context, snapshot) {
          final error = snapshot.error;
          if (error != null) {
            return Text(error.toString());
          }
          final data = snapshot.data;

          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Row(
            children: [
              Expanded(
                child: LineChart(LineChartData(
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: getSignals(data),
                    minY: GraphSignalStrength.minStrength,
                    maxY: GraphSignalStrength.maxStrength,
                    minX: startShowFrequency.toDouble(),
                    maxX: min(endShowFrequency.toDouble(), 5325),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                          getTitlesWidget: (value, meta) {
                            return Text("${value.toInt()} dB");
                          },
                          reservedSize: 25,
                        ),
                      ),
                      rightTitles: endShowFrequency > 5320
                          ? const AxisTitles(
                              sideTitles: SideTitles(showTitles: false))
                          : const AxisTitles(
                              axisNameWidget: Text('Power Level'),
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 0,
                              ),
                            ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final channel = networkBandMap[value];

                            if (channel != null) {
                              return Text("$channel");
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                          reservedSize: 33,
                        ),
                      ),
                    ))),
              ),
              if (endShowFrequency > 5320)
                Expanded(
                  child: LineChart(LineChartData(
                      lineTouchData: const LineTouchData(enabled: false),
                      lineBarsData: getSignals(data),
                      minY: GraphSignalStrength.minStrength,
                      maxY: GraphSignalStrength.maxStrength,
                      minX: 5730,
                      maxX: endShowFrequency.toDouble(),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                          axisNameWidget: Text('Power Level'),
                          sideTitles: SideTitles(
                            showTitles: false,
                            reservedSize: 0,
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final channel = networkBandMap[value];

                              if (channel != null) {
                                return Text("$channel");
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                            reservedSize: 33,
                          ),
                        ),
                      ))),
                )
            ],
          );
        });
  }
}
