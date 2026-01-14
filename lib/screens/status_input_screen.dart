import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/status_provider.dart';
import '../theme/app_theme.dart';

class StatusInputScreen extends StatefulWidget {
  const StatusInputScreen({super.key});

  @override
  State<StatusInputScreen> createState() => _StatusInputScreenState();
}

class _StatusInputScreenState extends State<StatusInputScreen> {
  String _selectedEmoji = '😊';
  final TextEditingController _messageController = TextEditingController();
  final int _maxLength = 50;

  // 인기 이모지 목록
  final List<String> _popularEmojis = [
    '😊', '😌', '😔', '😴', '😎',
    '🥰', '😢', '😡', '🤔', '😍',
    '💚', '💙', '💜', '❤️', '🧡',
    '🎉', '✨', '🌟', '💫', '🔥',
  ];

  @override
  void initState() {
    super.initState();
    // 위젯이 빌드된 후 상태를 불러오기 위해 post-frame callback 사용
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentStatus = context.read<StatusProvider>().myTodayStatus;
      if (currentStatus != null && currentStatus.isToday) {
        setState(() {
          _selectedEmoji = currentStatus.emoji;
          _messageController.text = currentStatus.message;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _saveStatus() {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('상태 메시지를 입력해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (message.length > _maxLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('메시지는 최대 $_maxLength자까지 입력 가능합니다'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<StatusProvider>().saveMyStatus(_selectedEmoji, message);
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('상태가 저장되었습니다'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 상태'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '이모지를 선택해주세요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // 이모지 선택 그리드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _popularEmojis.length,
                itemBuilder: (context, index) {
                  final emoji = _popularEmojis[index];
                  final isSelected = _selectedEmoji == emoji;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEmoji = emoji;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryPurple
                            : AppTheme.accentPurple,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // 선택된 이모지 미리보기
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _selectedEmoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '오늘의 상태를 한 문장으로 표현해주세요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLength: _maxLength,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '예: 오늘은 혼자 있고 싶음',
                counterText: '',
              ),
              onChanged: (value) {
                setState(() {}); // 카운터 업데이트를 위해
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_messageController.text.length}/$_maxLength',
                style: TextStyle(
                  fontSize: 12,
                  color: _messageController.text.length > _maxLength
                      ? Colors.red
                      : Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveStatus,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

