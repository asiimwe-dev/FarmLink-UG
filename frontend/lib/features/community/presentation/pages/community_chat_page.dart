import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_typography.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/imessage_bubble.dart';
import 'package:farmcom/core/presentation/widgets/modern_chat_input.dart';

class CommunityChatPage extends StatefulWidget {
  final String communityName;
  final String communityId;
  final String members;

  const CommunityChatPage({
    super.key,
    required this.communityName,
    required this.communityId,
    required this.members,
  });

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {
      'user': 'James Mukwaya',
      'text': 'Just harvested my coffee crop! Quality is great this season.',
      'isMe': false,
      'time': '10:30 AM',
      'role': 'Farmer'
    },
    {
      'user': 'Sarah Katende',
      'text': 'James, that\'s awesome! What did you get for your yield?',
      'isMe': false,
      'time': '10:35 AM',
      'role': 'Farmer'
    },
    {
      'user': 'Me',
      'text': 'About 250kg from my 2-acre plot. Using the new irrigation method helped a lot.',
      'isMe': true,
      'time': '10:42 AM',
      'role': 'Farmer'
    },
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
      _messages.add({
        'user': 'Me',
        'text': text,
        'isMe': true,
        'time': 'Just now',
        'role': 'Farmer'
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  DateTime? _parseTime(String timeStr) {
    if (timeStr == 'Just now') {
      return DateTime.now();
    }
    // Parse time format like "10:30 AM"
    try {
      final now = DateTime.now();
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        final minutePart = parts[1].split(' ');
        final minute = int.parse(minutePart[0]);
        final period = minutePart.length > 1 ? minutePart[1] : '';

        if (period == 'PM' && hour != 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;

        return DateTime(now.year, now.month, now.day, hour, minute);
      }
    } catch (_) {}
    return null;
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.communityName,
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w900, 
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            Text(
              '${widget.members} members',
              style: TextStyle(AppTypography.captionSmall, color: isDark ? Colors.white60 : AppColors.grey500, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
          const SizedBox(width: 8),
        ],
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
                return CommunityChatBubble(
                  text: message['text'],
                  isUser: message['isMe'],
                  senderName: message['user'],
                  senderRole: message['role'],
                  timestamp: _parseTime(message['time']),
                  isExpert: message['role'] == 'Expert',
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
            hintText: 'Share with community...',
          ),
        ],
      ),
    );
  }
}
