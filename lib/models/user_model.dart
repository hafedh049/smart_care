import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String phoneNumber;
  final String role;
  final String username;
  final String email;
  final String password;

  UserModel({required this.phoneNumber, required this.role, required this.username, required this.email, required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(phoneNumber: json['phoneNumber'], role: json['role'], username: json['username'], email: json['email'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'role': role, 'username': username, 'email': email, 'password': password};
  }

  Future<UserCredential> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
