import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_care/models/message_model.dart';
import 'package:smart_care/stuff/functions.dart';

import '../models/user_model.dart';

class ChatViewModel extends GetxController {
  UserModel userModel = UserModel(email: '', password: '', phoneNumber: '', role: '', username: '');
  MessageModel messageModel = MessageModel();
  List<Map<String, dynamic>> messages = [];

  void getMessages() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('messages').get();
      messages = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState();
    } catch (error) {
      showError();
      print('Error getting messages: $error');
    }
  }

  void setState() {
    update();
  }

  String getMessage() {
    return messageModel.message!;
  }

  void addMessage(String msg) async {
    try {
      final CollectionReference messagesCollection = FirebaseFirestore.instance.collection('messages');

      final DocumentReference newMessageRef = messagesCollection.doc();

      await newMessageRef.set(messageModel.toJson());

      showMessage();
    } catch (error) {
      showError();
      print('Error adding message: $error');
    }
  }

  void showMessage() {
    Fluttertoast.showToast(msg: "Operation Terminated Successfully");
  }

  void sendNotification(String message, String token) {
    sendPushNotificationFCM(token: token, username: userModel.username, message: message);
  }

  void showError() {
    Fluttertoast.showToast(msg: 'Error Occurred');
  }
}
