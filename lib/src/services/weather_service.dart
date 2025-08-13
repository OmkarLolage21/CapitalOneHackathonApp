import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../core/di.dart';
import 'package:flutter/material.dart';

final weatherProvider = FutureProvider<WeatherModel>((ref) async {
  final dio = ref.read(dioProvider);
  final res = await dio.get('/webhook/weather?lat=18.52&lon=73.85'); // plug in GPS
  return WeatherModel.fromJson(res.data as Map<String, dynamic>);
});

class WeatherModel {
  final String currentSummary; final String currentDetail; final String irrigationAdvice; final String reasoning; final List<Day> days;
  WeatherModel({required this.currentSummary, required this.currentDetail, required this.irrigationAdvice, required this.reasoning, required this.days});
  factory WeatherModel.fromJson(Map<String, dynamic> j) => WeatherModel(
    currentSummary: j['currentSummary'] ?? '—',
    currentDetail: j['currentDetail'] ?? '—',
    irrigationAdvice: j['irrigationAdvice'] ?? '—',
    reasoning: j['reasoning'] ?? '—',
    days: (j['days'] as List).map((e) => Day.fromJson(e)).toList(),
  );
}
class Day { final String label; final IconData icon; final String temp; Day({required this.label, required this.icon, required this.temp});
  factory Day.fromJson(Map<String, dynamic> j) => Day(label: j['label'], icon: Icons.cloud, temp: j['temp']);
}
