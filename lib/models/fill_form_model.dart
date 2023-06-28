import 'package:cloud_firestore/cloud_firestore.dart';

class FillForm {
  List<String> choices;
  String conduiteATenir;

  FillForm({
    required this.choices,
    required this.conduiteATenir,
  });

  Future<void> saveForm() async {
    try {
      // Create a new document in the "forms" collection
      final docRef = FirebaseFirestore.instance.collection('forms').doc();

      // Save the form data in the document
      await docRef.set({
        'choices': choices,
        'conduiteATenir': conduiteATenir,
      });

      // Success, form saved
      print('Form saved successfully!');
    } catch (e) {
      // Error occurred while saving the form
      print('Failed to save form: $e');
      rethrow;
    }
  }
}
