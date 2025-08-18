import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DummyOfficerLineChart extends StatelessWidget {
  const DummyOfficerLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<double> prices = [1950, 1970, 1960, 1985, 2000, 2020, 2010];
    return LineChart(
      LineChartData(
        minY: prices.reduce((a, b) => a < b ? a : b) * 0.98,
        maxY: prices.reduce((a, b) => a > b ? a : b) * 1.02,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                if (value % 20 == 0) return Text('${value.toInt()}');
                return const SizedBox.shrink();
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt() + 1}');
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: Colors.indigo.shade50)),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(7, (i) => FlSpot(i.toDouble(), prices[i])),
            isCurved: true,
            color: Colors.indigo.shade700,
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                  colors: [Colors.indigo.shade100, Colors.indigo.shade50]),
            ),
            dotData: FlDotData(show: true),
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.indigo.shade50, strokeWidth: 1),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => touchedSpots
                .map((spot) => LineTooltipItem(
                      '${spot.y.toStringAsFixed(0)} ₹',
                      const TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class DummyInteractiveLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const DummyInteractiveLineChart({required this.data, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) {},
      child: CustomPaint(
        painter: _LineChartPainter(data),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.indigo.shade400
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final paintGrid = Paint()
      ..color = Colors.indigo.shade100
      ..strokeWidth = 1;

    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    if (data.isEmpty) return;

    final points = List.generate(data.length, (i) {
      final x = size.width * i / (data.length - 1);
      final modal = (data[i]['modal'] as num).toDouble();
      final y = size.height * (1 - ((modal - 1950) / 100));
      return Offset(x, y);
    });

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
