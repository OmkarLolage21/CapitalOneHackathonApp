import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:dio/dio.dart';
import '../core/di.dart';

final marketProvider = FutureProvider<MarketModel>((ref) async {
  final dio = ref.read(dioProvider);
  final res = await dio.get('/webhook/market?crop=cotton&district=Pune');
  return MarketModel.fromJson(res.data as Map<String, dynamic>);
});

class MarketModel {
  final String selectedCrop; final List<String> crops; final String recommendation;
  MarketModel({required this.selectedCrop, required this.crops, required this.recommendation});
  factory MarketModel.fromJson(Map<String, dynamic> j) => MarketModel(
    selectedCrop: j['selectedCrop'],
    crops: List<String>.from(j['crops'] ?? []),
    recommendation: j['recommendation'] ?? '—',
  );
}