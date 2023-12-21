import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_care/stuff/functions.dart';

class CreateArticlePage extends StatefulWidget {
  @override
  _CreateArticlePageState createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _saveArticle() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('articles').add({
          'title': title,
          'content': content,
          'publishedAt': DateTime.now(),
        });

        showToast(text: 'Article saved successfully');

        // Clear the input fields
        _titleController.clear();
        _contentController.clear();
      } catch (error) {
        showToast(text: 'Error saving article');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Article')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: 'Content',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveArticle,
              child: Text('Save Article'),
            ),
          ],
        ),
      ),
    );
  }
}
