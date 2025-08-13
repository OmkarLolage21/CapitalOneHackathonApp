import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../services/market_service.dart';

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(marketProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Market Prices')),
      body: async.when(
        data: (model) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButton<String>(
              value: model.selectedCrop,
              items: model.crops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 12),
            Card(child: ListTile(title: const Text('Hold/Sell'), subtitle: Text(model.recommendation))),
            const SizedBox(height: 12),
            Card(child: Column(children: [
              const ListTile(title: Text('7-day Trend')),
              SizedBox(height: 160, child: Placeholder()), // plug in fl_chart line chart
            ])),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
