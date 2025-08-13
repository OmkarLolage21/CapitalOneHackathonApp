import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' as hr;
import 'package:image_picker/image_picker.dart';

// Message model for new chat system
class ChatMessage {
  final String text;
  final String role; // 'user' or 'assistant'
  final String? imagePath;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.role,
    this.imagePath,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

// Chat controller using flutter_riverpod
class ChatController extends StateNotifier<List<ChatMessage>> {
  ChatController() : super([]);

  void sendText({required String text, required String locale}) {
    // Add user message
    state = [ChatMessage(text: text, role: 'user'), ...state];
    
    // Simulate AI response (replace with actual service call)
    _simulateResponse(text, locale);
  }

  void sendWithImage({required String text, required String locale, required XFile image}) {
    // Add user message with image
    state = [ChatMessage(text: text, role: 'user', imagePath: image.path), ...state];
    
    // Simulate AI response (replace with actual service call)
    _simulateResponse(text, locale);
  }

  void _simulateResponse(String userText, String locale) {
    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      final response = _generateResponse(userText);
      state = [ChatMessage(text: response, role: 'assistant'), ...state];
    });
  }

  String _generateResponse(String userText) {
    // Simple response simulation - replace with actual AI service
    if (userText.toLowerCase().contains('weather')) {
      return 'Based on current data, expect sunny weather with 28°C. Good conditions for farming activities.';
    } else if (userText.toLowerCase().contains('pest')) {
      return 'I can see signs of pest activity. Consider using neem oil spray as an organic solution.';
    } else if (userText.toLowerCase().contains('crop') || userText.toLowerCase().contains('plant')) {
      return 'Your crops are looking healthy. Make sure to monitor soil moisture levels.';
    } else {
      return 'I understand your question about farming. Let me provide some helpful advice based on current conditions.';
    }
  }

  void clear() {
    state = [];
  }
}

// Provider for the chat controller
final chatControllerProvider = StateNotifierProvider<ChatController, List<ChatMessage>>((ref) {
  return ChatController();
});

// Compatibility provider for existing code
final chatServiceProvider = hr.Provider<ChatService>((ref) => ChatService());

class ChatService {
  // Placeholder for compatibility with existing code
  Future<ChatReply> ask(String text, {dynamic media}) async {
    await Future.delayed(const Duration(seconds: 1));
    return ChatReply('AI response to: $text', []);
  }
}

class ChatReply {
  final String text;
  final List<dynamic> sources;
  ChatReply(this.text, this.sources);
}