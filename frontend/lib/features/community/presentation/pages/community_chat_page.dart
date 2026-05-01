import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';
import 'package:farmlink_ug/core/theme/spacing_constants.dart';
import 'package:farmlink_ug/core/presentation/widgets/modern_chat_bubble.dart';
import 'package:farmlink_ug/core/presentation/widgets/modern_chat_input.dart';
import 'package:farmlink_ug/core/presentation/widgets/offline_indicator.dart';

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
    {'user': 'James Mukwaya', 'text': 'Just harvested my coffee crop!', 'isMe': false, 'time': '10:30 AM', 'role': 'Farmer'},
    {'user': 'Sarah Katende', 'text': 'James, that\'s awesome!', 'isMe': false, 'time': '10:35 AM', 'role': 'Farmer'},
    {'user': 'Me', 'text': 'About 250kg from my 2-acre plot.', 'isMe': true, 'time': '10:42 AM', 'role': 'Farmer'},
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
      _messages.add({'user': 'Me', 'text': text, 'isMe': true, 'time': 'Just now', 'role': 'Farmer'});
    });
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  DateTime? _parseTime(String timeStr) {
    if (timeStr == 'Just now') return DateTime.now();
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
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.grey50,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: isDark ? 4 : 2,
        backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.textPrimary, size: 20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.communityName, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800, color: isDark ? Colors.white : AppColors.textPrimary)),
            Text('${widget.members} members', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded), color: isDark ? Colors.white : AppColors.textPrimary),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded), color: isDark ? Colors.white : AppColors.textPrimary),
          const SizedBox(width: SpacingConstants.paddingMD),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(SpacingConstants.paddingLG),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ModernChatBubble(
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
              ModernChatInputArea(
                controller: _messageController,
                onSend: _sendMessage,
                onAttach: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Media attachment coming soon!'))),
                onMic: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice message coming soon!'))),
                hintText: 'Share with community...',
              ),
            ],
          ),
          Positioned(top: 0, left: 0, right: 0, child: OfflineIndicator()),
        ],
      ),
    );
  }
}
