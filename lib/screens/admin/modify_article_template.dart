import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';

class ModifyArticleTemplate extends StatefulWidget {
  const ModifyArticleTemplate({super.key, required this.ref});
  final DocumentReference<Map<String, dynamic>> ref;
  @override
  State<ModifyArticleTemplate> createState() => _ModifyArticleTemplateState();
}

class _ModifyArticleTemplateState extends State<ModifyArticleTemplate> {
  String _selectedCategory = "Politics";
  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _channelNameController.dispose();
    _descriptionController.dispose();
    _authorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: const CustomizedText(text: "Create a new channel", fontSize: 16, color: blue),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) => _(() => _selectedCategory = newValue!),
                    items: <String>['Politics', 'Education', 'Sport', 'Health', 'World', 'Gaming', 'Astronomy']
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(value: value, child: CustomizedText(text: value, fontSize: 14)),
                        )
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(controller: _titleController, decoration: const InputDecoration(hintText: "Article Title", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _channelNameController, decoration: const InputDecoration(hintText: "Channel Name", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _descriptionController, maxLines: 5, keyboardType: TextInputType.multiline, decoration: const InputDecoration(hintText: "Description", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _contentController, maxLines: 5, keyboardType: TextInputType.multiline, decoration: const InputDecoration(hintText: "Content", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _authorNameController, decoration: const InputDecoration(hintText: "Author name", border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const CustomizedText(text: "Cancel", fontSize: 16, color: grey)),
          ElevatedButton(
            onPressed: () {
              String category = _selectedCategory;
              String title = _titleController.text.trim();
              String channelName = _channelNameController.text.trim();
              String description = _descriptionController.text.trim();
              String content = _descriptionController.text.trim();
              String authorName = _authorNameController.text.trim();

              if (channelName.isNotEmpty && description.isNotEmpty && authorName.isNotEmpty) {
                widget.ref.update(<String, dynamic>{
                  "author": authorName,
                  "content": content,
                  "description": description,
                  "topic": category,
                  "title": title,
                  "source.name": channelName,
                });
              } else {
                showToast(text: "Some fields are empty");
              }

              Navigator.of(context).pop();
            },
            child: const CustomizedText(text: "Update", fontSize: 16, color: blue),
          ),
        ],
      ),
    );
  }
}
