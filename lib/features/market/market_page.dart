import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/spacing.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  String selectedCrop = 'Cotton';
  final crops = ['Cotton', 'Rice', 'Wheat', 'Sugarcane', 'Soybean'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Market Prices')),
      body: ListView(
        padding: const EdgeInsets.all(Gaps.md),
        children: [
          // Crop selector
          Card(
            child: Padding(
              padding: kCardPadding,
              child: Row(
                children: [
                  Icon(Icons.agriculture, color: scheme.primary),
                  const SizedBox(width: Gaps.sm),
                  Text('Crop:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: Gaps.sm),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedCrop,
                      isExpanded: true,
                      items: crops.map((crop) => DropdownMenuItem(value: crop, child: Text(crop))).toList(),
                      onChanged: (value) => setState(() => selectedCrop = value ?? selectedCrop),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Gaps.md),
          
          // Current price and recommendation
          Card(
            child: Padding(
              padding: kCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: scheme.primary),
                      const SizedBox(width: Gaps.sm),
                      Text('Current Price', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: Gaps.sm),
                  Text('₹4,250 per quintal', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: scheme.primary)),
                  const SizedBox(height: Gaps.xs),
                  _RiskChip(label: 'Hold recommended', type: RiskType.medium),
                  const SizedBox(height: Gaps.sm),
                  const Text('Price expected to rise by 8% in next 2 weeks based on market trends.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: Gaps.md),

          // Price chart
          Card(
            child: Padding(
              padding: kCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.show_chart, color: scheme.primary),
                      const SizedBox(width: Gaps.sm),
                      Text('7-Day Price Trend', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: Gaps.lg),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        backgroundColor: scheme.surface,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: scheme.outline.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45,
                              getTitlesWidget: (value, meta) => Text(
                                '₹${value.toInt()}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                if (value.toInt() < days.length) {
                                  return Text(days[value.toInt()], style: Theme.of(context).textTheme.bodySmall);
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 4100),
                              FlSpot(1, 4150),
                              FlSpot(2, 4080),
                              FlSpot(3, 4200),
                              FlSpot(4, 4180),
                              FlSpot(5, 4220),
                              FlSpot(6, 4250),
                            ],
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [scheme.primary, scheme.primaryContainer],
                            ),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                radius: 4,
                                color: scheme.primary,
                                strokeWidth: 2,
                                strokeColor: scheme.surface,
                              ),
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  scheme.primary.withOpacity(0.3),
                                  scheme.primary.withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Gaps.md),

          // Market alerts
          Card(
            child: Padding(
              padding: kCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_active, color: scheme.primary),
                      const SizedBox(width: Gaps.sm),
                      Text('Market Alerts', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: Gaps.sm),
                  const _AlertItem(
                    icon: Icons.trending_up,
                    title: 'Price surge expected',
                    subtitle: 'Cotton prices may increase by 10% next week',
                    risk: RiskType.low,
                  ),
                  const _AlertItem(
                    icon: Icons.warning,
                    title: 'Weather impact',
                    subtitle: 'Rain may affect harvest timing',
                    risk: RiskType.medium,
                  ),
                  const _AlertItem(
                    icon: Icons.info,
                    title: 'Government announcement',
                    subtitle: 'New MSP rates declared',
                    risk: RiskType.low,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum RiskType { low, medium, high }

class _RiskChip extends StatelessWidget {
  final String label;
  final RiskType type;

  const _RiskChip({required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    
    switch (type) {
      case RiskType.low:
        color = const Color(0xFF10B981);
        icon = Icons.check_circle_outline;
        break;
      case RiskType.medium:
        color = const Color(0xFFF59E0B);
        icon = Icons.warning_amber_outlined;
        break;
      case RiskType.high:
        color = const Color(0xFFEF4444);
        icon = Icons.error_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final RiskType risk;

  const _AlertItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.risk,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            radius: 20,
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: Gaps.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          _RiskChip(
            label: risk == RiskType.low ? 'Info' : risk == RiskType.medium ? 'Watch' : 'Alert',
            type: risk,
          ),
        ],
      ),
    );
  }
}