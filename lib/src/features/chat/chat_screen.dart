import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/chat_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ChatUser me = ChatUser(id: 'me', firstName: 'You');
  final ChatUser bot = ChatUser(id: 'bot', firstName: 'AgriBot');
  List<ChatMessage> messages = [];

  Future<void> _send(String text, {List<ChatMedia>? medias}) async {
    final msg = ChatMessage(user: me, createdAt: DateTime.now(), text: text, medias: medias);
    setState(() => messages = [msg, ...messages]);
    final reply = await ref.read(chatServiceProvider).ask(text, media: medias);
    setState(() => messages = [
      ChatMessage(user: bot, createdAt: DateTime.now(), text: reply.text, customProperties: {'sources': reply.sources}),
      ...messages
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Advisor')),
      body: DashChat(
        currentUser: me,
        messages: messages,
        messageOptions: const MessageOptions(showTime: true),
        onSend: (m) => _send(m.text),
        inputOptions: InputOptions(
          trailing: [
            IconButton(
              icon: const Icon(Icons.photo),
              onPressed: () async {
                final img = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (img != null) {
                  final media = ChatMedia(url: img.path, fileName: img.name, type: MediaType.image);
                  await _send('Analyze this image', medias: [media]);
                }
              },
            ),
          ],
        ),
        messageListOptions: const MessageListOptions(),
      ),
    );
  }
}