import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../services/weather_service.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Weather & Irrigation")),
      body: async.when(
        data: (model) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(child: ListTile(title: Text('Today: ${model.currentSummary}'), subtitle: Text(model.currentDetail))),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('7-day Forecast', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) => _DayTile(day: model.days[i].label, icon: model.days[i].icon, temp: model.days[i].temp),
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: model.days.length,
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Card(child: ListTile(title: const Text('Irrigation Recommendation'), subtitle: Text(model.irrigationAdvice))),
            TextButton(onPressed: () => _showWhy(context, model.reasoning), child: const Text('Why?')),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showWhy(BuildContext context, String reasoning) {
    showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => Padding(
      padding: const EdgeInsets.all(16), child: SingleChildScrollView(child: Text(reasoning)),
    ));
  }
}

class _DayTile extends StatelessWidget {
  final String day; final IconData icon; final String temp;
  const _DayTile({required this.day, required this.icon, required this.temp});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Theme.of(context).colorScheme.surfaceVariant),
      padding: const EdgeInsets.all(12),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon), const SizedBox(height: 6), Text(day), Text(temp, style: const TextStyle(fontWeight: FontWeight.bold))]),
    );
  }
}