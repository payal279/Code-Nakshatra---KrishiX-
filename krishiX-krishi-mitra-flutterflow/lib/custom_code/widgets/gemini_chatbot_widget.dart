// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart'; // Kept for the Speaker Icon
import 'package:flutter_markdown/flutter_markdown.dart'; // Kept for Bold Text/Lists

// --- THEME CONFIGURATION ---
class FarmerTheme {
  static const Color primaryGreen = Color(0xFF1B5E20); // Darker, premium green
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color background = Color(0xFFF2F4F0); // Very light grey-green
  static const Color userBubble = Color(0xFF2E7D32);
  static const Color botBubble = Colors.white;
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Colors.white;
}

class GeminiChatbotWidget extends StatefulWidget {
  const GeminiChatbotWidget({
    Key? key,
    this.width,
    this.height,
    required this.geminiApiKey,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String geminiApiKey;

  @override
  _GeminiChatbotWidgetState createState() => _GeminiChatbotWidgetState();
}

class _GeminiChatbotWidgetState extends State<GeminiChatbotWidget> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // TTS (Text to Speech) State
  final FlutterTts _flutterTts = FlutterTts();
  String? _currentlySpeakingId;

  // API Config (Using the working 1.5 Flash model)
  final String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _currentlySpeakingId = null);
    });
    _flutterTts.setErrorHandler((msg) {
      if (mounted) setState(() => _currentlySpeakingId = null);
    });
    // Set language to Malayalam (ml-IN)
    _flutterTts.setLanguage("ml-IN");
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  // --- LOGIC: TTS ---
  Future<void> _speak(String text, String messageId) async {
    if (_currentlySpeakingId == messageId) {
      await _stopSpeak();
    } else {
      await _stopSpeak();
      setState(() => _currentlySpeakingId = messageId);
      await _flutterTts.speak(text);
    }
  }

  Future<void> _stopSpeak() async {
    await _flutterTts.stop();
    if (mounted) setState(() => _currentlySpeakingId = null);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final userMessageText = _inputController.text.trim();
    if (userMessageText.isEmpty) return;

    final userMessageId = 'user_${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      _messages.add({
        'id': userMessageId,
        'text': userMessageText,
        'sender': 'user',
        'time': _getCurrentTime()
      });
      _inputController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final chatHistory = _messages
          .map((msg) => {
                'role': msg['sender'] == 'user' ? 'user' : 'model',
                'parts': [
                  {'text': msg['text']}
                ]
              })
          .toList();

      // System instruction requesting Markdown
      final systemInstruction = {
        'parts': [
          {
            'text':
                'You are Karshaka-Sahayi, trained by shaswat, a helpful agricultural expert for Kerala. Use simple language. Format your response using Markdown (bold keys, bullet points) for readability. Keep answers concise.'
          }
        ]
      };

      final Map<String, dynamic> payload = {
        'system_instruction': systemInstruction,
        'contents': chatHistory,
      };

      final response = await http.post(
        Uri.parse('$_apiUrl?key=${widget.geminiApiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('API Error: ${response.statusCode}');
      }

      final result = jsonDecode(response.body);
      String botResponseText = result['candidates']?[0]?['content']?['parts']
              ?[0]?['text'] ??
          'ക്ഷമിക്കണം, ഇപ്പോൾ ഉത്തരം നൽകാൻ കഴിയില്ല.';

      final botMessageId = 'bot_${DateTime.now().millisecondsSinceEpoch}';
      setState(() {
        _messages.add({
          'id': botMessageId,
          'text': botResponseText,
          'sender': 'bot',
          'time': _getCurrentTime()
        });
      });
    } catch (error) {
      setState(() => _messages.add({
            'id': 'error',
            'text': 'Connection Error. Please try again.',
            'sender': 'bot',
            'time': _getCurrentTime()
          }));
    } finally {
      if (mounted) setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: FarmerTheme.background,
      child: Column(
        children: [
          _buildGlassHeader(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                  top: 20, left: 16, right: 16, bottom: 20),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingAnimation();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          if (_messages.isEmpty) _buildQuickReplySection(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildGlassHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: FarmerTheme.primaryGreen,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(Icons.agriculture_rounded,
                  color: FarmerTheme.primaryGreen, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Karshaka-Sahayi',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: Colors.greenAccent, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Online',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                setState(() {
                  _messages.clear();
                  _isLoading = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    final isSpeaking = _currentlySpeakingId == message['id'];

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              // Speaker Button (TTS)
              GestureDetector(
                onTap: () => _speak(message['text']!, message['id']!),
                child: Container(
                  margin: EdgeInsets.only(right: 8, bottom: 4),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: isSpeaking
                          ? Colors.redAccent.withOpacity(0.1)
                          : Colors.transparent,
                      shape: BoxShape.circle),
                  child: Icon(
                    isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded,
                    color: isSpeaking ? Colors.redAccent : Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      isUser ? FarmerTheme.userBubble : FarmerTheme.botBubble,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: isUser
                        ? const Radius.circular(20)
                        : const Radius.circular(4),
                    bottomRight: isUser
                        ? const Radius.circular(4)
                        : const Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: Offset(0, 2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Render Markdown for Bots, Plain text for Users
                    isUser
                        ? Text(
                            message['text']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                        : MarkdownBody(
                            data: message['text']!,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                  color: FarmerTheme.textDark, fontSize: 15),
                              strong: TextStyle(
                                  color: FarmerTheme.primaryGreen,
                                  fontWeight: FontWeight.bold),
                              listBullet:
                                  TextStyle(color: FarmerTheme.primaryGreen),
                            ),
                          ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        message['time']!,
                        style: TextStyle(
                          color: isUser ? Colors.white70 : Colors.grey,
                          fontSize: 10,
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
    );
  }

  Widget _buildTypingAnimation() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: FarmerTheme.primaryGreen,
            child: Icon(Icons.psychology, size: 16, color: Colors.white),
          ),
          SizedBox(width: 8),
          Text(
            "ചിന്തിക്കുന്നു...",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplySection() {
    final questions = ['തെങ്ങിന് വളം', 'നെൽക്കൃഷി', 'മഴ മുന്നറിയിപ്പ്'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: questions
            .map((q) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    label: Text(q),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                        color: FarmerTheme.primaryGreen.withOpacity(0.3)),
                    labelStyle: TextStyle(color: FarmerTheme.primaryGreen),
                    onPressed: () {
                      _inputController.text = q;
                      _sendMessage();
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -4))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: 'ചോദ്യം ചോദിക്കുക...',
                filled: true,
                fillColor: FarmerTheme.background,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            mini: true,
            onPressed: _isLoading ? null : _sendMessage,
            backgroundColor: FarmerTheme.primaryGreen,
            child: _isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : Icon(Icons.send_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}
