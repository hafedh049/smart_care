import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_care/models/user_model.dart';

class AdminModel extends UserModel {
  final String uid;

  AdminModel({required String phoneNumber, required String role, required String username, required String email, required String password, required this.uid})
      : super(
          phoneNumber: phoneNumber,
          role: role,
          username: username,
          email: email,
          password: password,
        );

  Future<void> addUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createArticle() async {
    try {
      await FirebaseFirestore.instance.collection('articles').doc().set({});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteArticle() async {
    try {
      await FirebaseFirestore.instance.collection('articles').doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }
}
