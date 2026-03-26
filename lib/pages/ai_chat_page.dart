import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/fitness_repository.dart';
import '../services/zhipu_ai_service.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key, required this.repository});

  final FitnessRepository repository;

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  static const String _chatStorageKey = 'ai.chat.messages.v1';
  static const String _botNameStorageKey = 'ai.chat.botName.v1';

  final ZhipuAiService _service = ZhipuAiService();
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _botNameController = TextEditingController(text: 'Coach Nova');
  List<_ChatMessage> _messages = [
    const _ChatMessage(
      role: _MessageRole.assistant,
      text: 'Hi! I am your AI workout assistant. Ask me anything about training, recovery, or nutrition.',
    ),
  ];
  bool _sending = false;
  String _botName = 'Coach Nova';
  final List<String> _presetQuestions = const [
    'Can you build a 7-day beginner workout plan for fat loss?',
    'What is a safe warm-up before strength training?',
    'How should I train chest and back in one session?',
    'Please suggest a 20-minute HIIT routine at home.',
    'What should I eat after a workout for recovery?',
    'How do I avoid knee pain during squats?',
  ];

  void _dismissKeyboard() {
    final focus = FocusScope.of(context);
    if (!focus.hasPrimaryFocus && focus.focusedChild != null) {
      focus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLocalChat();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _botNameController.dispose();
    super.dispose();
  }

  Future<void> _loadLocalChat() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_botNameStorageKey);
    final raw = prefs.getString(_chatStorageKey);
    List<_ChatMessage> restored = const [];
    if (raw != null && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          restored = decoded
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .map(_ChatMessage.fromMap)
              .where((m) => m.text.trim().isNotEmpty)
              .toList();
        }
      } catch (_) {
        restored = const [];
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      if (savedName != null && savedName.trim().isNotEmpty) {
        _botName = savedName.trim();
      }
      if (restored.isNotEmpty) {
        _messages = restored;
      }
    });
  }

  Future<void> _persistLocalChat() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(_messages.map((m) => m.toMap()).toList());
    await prefs.setString(_chatStorageKey, payload);
    await prefs.setString(_botNameStorageKey, _botName);
  }

  Future<void> _editBotName() async {
    _botNameController.text = _botName;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Bot'),
          content: TextField(
            controller: _botNameController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter bot name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final next = _botNameController.text.trim();
                if (next.isEmpty) {
                  return;
                }
                setState(() {
                  _botName = next;
                });
                _persistLocalChat();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _sending) {
      return;
    }
    if (!_service.isConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ZHIPU_API_KEY is not configured. Inject it with --dart-define and restart the app.'),
        ),
      );
      return;
    }
    final paid = await widget.repository.spendCoins(FitnessRepository.aiChatCostCoins, reason: 'ai_chat');
    if (!paid) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient Coins. Each AI conversation costs 1 Coin.')),
      );
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(role: _MessageRole.user, text: text));
      _sending = true;
      _inputController.clear();
    });
    await _persistLocalChat();

    try {
      final reply = await _service.chat(userMessage: text);
      if (!mounted) {
        return;
      }
      setState(() {
        _messages.add(_ChatMessage(role: _MessageRole.assistant, text: reply));
      });
      await _persistLocalChat();
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _messages.add(
          _ChatMessage(
            role: _MessageRole.assistant,
            text: 'Sorry, I could not reach the AI service right now.\n$e',
          ),
        );
      });
      await _persistLocalChat();
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  Future<void> _sendPresetQuestion(String question) async {
    if (_sending) {
      return;
    }
    _inputController.text = question;
    await _send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_botName),
        actions: [
          IconButton(
            tooltip: 'Rename bot',
            onPressed: _editBotName,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissKeyboard,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final m = _messages[index];
                  final mine = m.role == _MessageRole.user;
                  final bubble = Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      color: mine
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.16)
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m.text),
                  );
                  if (mine) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: bubble,
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage('assets/user_default.png'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: bubble,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                itemCount: _presetQuestions.length,
                separatorBuilder: (context, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final q = _presetQuestions[index];
                  return ActionChip(
                    onPressed: _sending ? null : () => _sendPresetQuestion(q),
                    avatar: const Icon(Icons.flash_on_rounded, size: 16),
                    label: Text(
                      q,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                child: Card(
                  elevation: 1,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              hintText: 'Type your question...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        FilledButton.tonal(
                          onPressed: _sending ? null : _send,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(44, 44),
                            padding: EdgeInsets.zero,
                          ),
                          child: _sending
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _MessageRole { user, assistant }

class _ChatMessage {
  const _ChatMessage({required this.role, required this.text});

  final _MessageRole role;
  final String text;

  Map<String, dynamic> toMap() {
    return {
      'role': role.name,
      'text': text,
    };
  }

  factory _ChatMessage.fromMap(Map<String, dynamic> map) {
    final roleName = map['role'] as String? ?? _MessageRole.assistant.name;
    final role = _MessageRole.values.firstWhere(
      (v) => v.name == roleName,
      orElse: () => _MessageRole.assistant,
    );
    return _ChatMessage(
      role: role,
      text: map['text'] as String? ?? '',
    );
  }
}
