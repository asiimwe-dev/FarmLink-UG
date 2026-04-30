import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/imessage_bubble.dart';
import 'package:farmcom/core/presentation/widgets/modern_chat_input.dart';

class AIChatPage extends ConsumerStatefulWidget {
  const AIChatPage({super.key});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! I\'m your FarmCom AI Assistant. How can I help you with your farm today?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: _generateAIResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  String _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('disease') || lowerMessage.contains('sick')) {
      return 'I can help with that. For accurate crop disease identification, please use our AI Quick-Scan feature on the dashboard. It uses specialized computer vision to analyze leaf patterns.\n\nCommon treatments for coffee rust include copper-based fungicides and ensuring proper spacing between plants.';
    } else if (lowerMessage.contains('price') || lowerMessage.contains('market')) {
      return 'Market prices are currently stable for Coffee but rising for Beans. You can find detailed buy/sell prices in the Market Pulse section of your dashboard.';
    } else if (lowerMessage.contains('help')) {
      return 'I can assist you with:\n• Disease diagnosis tips\n• Market price trends\n• Planting schedules\n• Community recommendations\n\nWhat would you like to explore?';
    }

    return 'That\'s an interesting point. Based on current agricultural best practices in East Africa, I recommend checking our Explore section for detailed steps on that specific crop management technique.\n\nWould you like me to find a specific guide for you?';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    AppTypography.titleMedium,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Always active',
                      style: AppTypography.captionSmall.copyWith( color: isDark ? Colors.white60 : AppColors.grey500, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return iMessageBubble(
                  text: message.text,
                  isUser: message.isUser,
                  timestamp: message.timestamp,
                );
              },
            ),
          ),
          ModernChatInput(
            controller: _messageController,
            onSend: _sendMessage,
            onAttach: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Media attachment feature coming soon!')),
              );
            },
            onMic: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice message feature coming soon!')),
              );
            },
            hintText: 'Ask me anything...',
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
