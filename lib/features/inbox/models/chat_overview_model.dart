class ChatOverviewModel {
  final String chatRoomId;
  final String otherUserId;
  final String otherUserName;
  final bool hasAvatar;
  final String lastMessage;
  final int lastMessageAt;
  final String lastMessageBy;

  ChatOverviewModel({
    required this.chatRoomId,
    required this.otherUserId,
    required this.otherUserName,
    required this.hasAvatar,
    this.lastMessage = '',
    this.lastMessageAt = 0,
    this.lastMessageBy = '',
  });

  ChatOverviewModel.fromJson(Map<String, dynamic> json)
      : chatRoomId = json['chatRoomId'],
        otherUserId = json['otherUserId'],
        otherUserName = json['otherUserName'],
        hasAvatar = json['hasAvatar'],
        lastMessage = json['lastMessage'],
        lastMessageAt = json['lastMessageAt'],
        lastMessageBy = json['lastMessageBy'];

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'hasAvatar': hasAvatar,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt,
      'lastMessageBy': lastMessageBy,
    };
  }

  ChatOverviewModel copyWith({
    String? chatRoomId,
    String? otherUserId,
    String? otherUserName,
    bool? hasAvatar,
    String? lastMessage,
    int? lastMessageAt,
    String? lastMessageBy,
  }) {
    return ChatOverviewModel(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageBy: lastMessageBy ?? this.lastMessageBy,
    );
  }
}
