class ChatMessage {
  final int? id;
  final String sender;
  final String content;
  final DateTime? timestamp;

  ChatMessage({
    this.id,
    required this.sender,
    required this.content,
    this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sender: json['sender'],
      content: json['content'],
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'content': content,
    };
  }
}
