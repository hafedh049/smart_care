class MessageModel {
  String? message;
  String? messageType;
  DateTime? timestamp;
  String? repliedMessage;
  String? senderId;
  String? toWho;
  String? messageId;

  MessageModel({
    this.message,
    this.messageType,
    this.timestamp,
    this.repliedMessage,
    this.senderId,
    this.toWho,
    this.messageId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      messageType: json['messageType'],
      timestamp: json['timestamp'],
      repliedMessage: json['repliedMessage'],
      senderId: json['senderId'],
      toWho: json['toWho'],
      messageId: json['messageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'messageType': messageType,
      'timestamp': timestamp!.toIso8601String(),
      'repliedMessage': repliedMessage,
      'senderId': senderId,
      'toWho': toWho,
      'messageId': messageId,
    };
  }
}
