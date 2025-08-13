import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/services/chat_service.dart';
import '../../l10n/l10n.dart';
import '../../theme/spacing.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();
  stt.SpeechToText? _speech;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatControllerProvider);
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.chat),
        actions: [
          IconButton(onPressed: () => ref.read(chatControllerProvider.notifier).clear(), icon: const Icon(Icons.delete_sweep_outlined), tooltip: 'Clear'),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(Gaps.md, Gaps.md, Gaps.md, 90),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[messages.length - 1 - i];
                final isUser = msg.role == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 360),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? LinearGradient(colors: [scheme.primary, scheme.primaryContainer])
                          : LinearGradient(colors: [scheme.surfaceContainerHighest, scheme.surface]),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isUser ? scheme.primary : Colors.black).withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (msg.imagePath != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(msg.imagePath!), width: 260),
                          ),
                          const SizedBox(height: 8),
                        ],
                        SelectableText(
                          msg.text,
                          style: TextStyle(color: isUser ? scheme.onPrimary : scheme.onSurface),
                        ),
                        if (!isUser)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Wrap(
                              spacing: 8,
                              children: [
                                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.info_outline), label: Text(l.why)),
                                TextButton(onPressed: () {}, child: Text(l.moreDetails)),
                                TextButton(onPressed: () {}, child: Text(l.translateToEnglish)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _Composer(
            controller: _controller,
            onSend: () {
              final text = _controller.text.trim();
              if (text.isEmpty) return;
              ref.read(chatControllerProvider.notifier).sendText(text: text, locale: locale);
              _controller.clear();
            },
            onMic: () async {
              if (_speech == null) return;
              if (!_listening) {
                final available = await _speech!.initialize();
                if (available) {
                  setState(() => _listening = true);
                  _speech!.listen(onResult: (r) {
                    setState(() => _controller.text = r.recognizedWords);
                  });
                }
              } else {
                _speech!.stop();
                setState(() => _listening = false);
              }
            },
            onAttachImage: () async {
              final file = await _picker.pickImage(source: ImageSource.camera);
              if (file == null) return;
              final text = _controller.text.trim().isEmpty ? 'Analyze this image' : _controller.text.trim();
              ref.read(chatControllerProvider.notifier).sendWithImage(text: text, locale: locale, image: file);
              _controller.clear();
            },
            listening: _listening,
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMic;
  final VoidCallback onAttachImage;
  final bool listening;

  const _Composer({
    required this.controller,
    required this.onSend,
    required this.onMic,
    required this.onAttachImage,
    required this.listening,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: Row(
          children: [
            IconButton(onPressed: onAttachImage, icon: const Icon(Icons.attachment_outlined), tooltip: l.attachImage),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(hintText: l.typeMessage, border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(onPressed: onMic, icon: Icon(listening ? Icons.stop_circle_outlined : Icons.mic_none), tooltip: listening ? l.stop : l.speak),
            const SizedBox(width: 6),
            FilledButton.tonalIcon(onPressed: onSend, icon: const Icon(Icons.send), label: const Text('Send')),
          ],
        ),
      ),
    );
  }
}