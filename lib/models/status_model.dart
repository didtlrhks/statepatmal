class StatusModel {
  final String id;
  final String userId;
  final String emoji;
  final String message;
  final DateTime createdAt;
  final bool isPublic;

  StatusModel({
    required this.id,
    required this.userId,
    required this.emoji,
    required this.message,
    required this.createdAt,
    this.isPublic = true,
  });

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'emoji': emoji,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'isPublic': isPublic,
    };
  }

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      emoji: json['emoji'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPublic: json['isPublic'] as bool? ?? true,
    );
  }

  // 오늘 날짜인지 확인
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  // 요약 메시지 (상대방에게 보여줄 때)
  String get summaryMessage {
    // 간단한 요약 로직 (나중에 개선 가능)
    if (message.length <= 20) {
      return message;
    }
    return '${message.substring(0, 20)}...';
  }
}

