import 'package:cloud_firestore/cloud_firestore.dart';

class Chatroom {
  String chatId;
  String patientId;
  String doctorId;

  Chatroom({
    required this.chatId,
    required this.patientId,
    required this.doctorId,
  });

  Future<void> addMessage(String message) async {
    try {
      // Get a reference to the chatroom document
      final chatRef = FirebaseFirestore.instance.collection('chatrooms').doc(chatId);

      // Add the message to the "messages" subcollection
      await chatRef.collection('messages').add({
        'message': message,
        'timestamp': DateTime.now().toString(),
      });

      // Success, message added
      print('Message added successfully!');
    } catch (e) {
      // Error occurred while adding the message
      print('Failed to add message: $e');
      throw e;
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      // Get a reference to the chatroom document
      final chatRef = FirebaseFirestore.instance.collection('chatrooms').doc(chatId);

      // Delete the message from the "messages" subcollection
      await chatRef.collection('messages').doc(messageId).delete();

      // Success, message deleted
      print('Message deleted successfully!');
    } catch (e) {
      // Error occurred while deleting the message
      print('Failed to delete message: $e');
      throw e;
    }
  }

  Future<void> replyToMessage(String messageId, String reply) async {
    try {
      // Get a reference to the chatroom document
      final chatRef = FirebaseFirestore.instance.collection('chatrooms').doc(chatId);

      // Add the reply to the message in the "messages" subcollection
      await chatRef.collection('messages').doc(messageId).update({
        'reply': reply,
      });

      // Success, message replied
      print('Message replied successfully!');
    } catch (e) {
      // Error occurred while replying to the message
      print('Failed to reply to message: $e');
      throw e;
    }
  }

  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      chatId: json['chatId'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'patientId': patientId,
      'doctorId': doctorId,
    };
  }
}
