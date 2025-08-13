import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';
import '../core/di.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService(ref.read(dioProvider)));

class ChatReply { final String text; final List<dynamic> sources; ChatReply(this.text, this.sources);
}

class ChatService {
  final Dio _dio; ChatService(this._dio);

  Future<ChatReply> ask(String text, {List<ChatMedia>? media}) async {
    final form = FormData.fromMap({
      'query': text,
      if (media != null && media.isNotEmpty) 'image': await MultipartFile.fromFile(media.first.url, filename: media.first.fileName),
      'lang': 'auto', // let n8n detect – your backend is multilingual
    });
    final res = await _dio.post('/webhook/chat', data: form);
    final data = res.data as Map<String, dynamic>;
    return ChatReply(data['answer'] ?? '…', data['sources'] ?? []);
  }
}