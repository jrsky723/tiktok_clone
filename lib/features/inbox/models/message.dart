class MessageModel {
  final String text;
  final String userId;
  final int createdAt;
  final String? messageId;
  final bool isDeleted;

  const MessageModel({
    required this.text,
    required this.userId,
    required this.createdAt,
    this.messageId,
    this.isDeleted = false,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        userId = json['userId'],
        createdAt = json['createdAt'],
        messageId = json['messageId'],
        isDeleted = json['isDeleted'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'userId': userId,
      'createdAt': createdAt,
      'isDeleted': isDeleted,
    };
  }

  MessageModel copyWith({
    String? text,
    String? userId,
    int? createdAt,
    String? messageId,
    bool? isDeleted,
  }) {
    return MessageModel(
      text: text ?? this.text,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      messageId: messageId ?? this.messageId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
