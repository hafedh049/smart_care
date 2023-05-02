import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/stuff/functions.dart';

import '../../stuff/classes.dart';
import '../../stuff/globals.dart';

class CreateArticle extends StatefulWidget {
  const CreateArticle({super.key});

  @override
  State<CreateArticle> createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  final List<String> _types = const <String>["Politics", "Sport", "Education", "Health", "World", "Gaming", "Astronomy"];
  String _type = "Health";
  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _articleTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _date;
  TimeOfDay? _time;
  String _linkOfArticle = "";
  String _articlePicture = noUser;
  String _channelLogo = noUser;

  @override
  void dispose() {
    _authorController.dispose();
    _articleTitleController.dispose();
    _channelNameController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: darkBlue,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: grey.withOpacity(.3)), width: 40, height: 40, child: const Center(child: Icon(FontAwesomeIcons.chevronLeft, size: 25, color: grey))),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            StatefulBuilder(
                              builder: (BuildContext context, void Function(void Function()) _) {
                                return CircleAvatar(
                                  radius: 30,
                                  backgroundColor: blue,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Clipboard.getData(Clipboard.kTextPlain).then((ClipboardData? value) {
                                        if (value != null) {
                                          if (value.text != null) {
                                            if (isImageUrl(value.text!)) {
                                              _(() => _articlePicture = value.text!);
                                            }
                                          }
                                        }
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: darkBlue,
                                      child: _articlePicture == noUser
                                          ? Icon(FontAwesomeIcons.clipboard, size: 30, color: grey.withOpacity(.8))
                                          : Stack(
                                              alignment: AlignmentDirectional.center,
                                              children: <Widget>[
                                                Icon(FontAwesomeIcons.certificate, size: 25, color: green.withOpacity(.4)),
                                                const Icon(FontAwesomeIcons.check, size: 16, color: green),
                                              ],
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            const CustomizedText(text: "Article Picture", color: white, fontSize: 16),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            StatefulBuilder(
                              builder: (BuildContext context, void Function(void Function()) _) {
                                return CircleAvatar(
                                  radius: 30,
                                  backgroundColor: blue,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Clipboard.getData(Clipboard.kTextPlain).then((ClipboardData? value) {
                                        if (value != null) {
                                          if (value.text != null) {
                                            if (isImageUrl(value.text!)) {
                                              _(() => _channelLogo = value.text!);
                                            }
                                          }
                                        }
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: darkBlue,
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: darkBlue,
                                        child: _channelLogo == noUser
                                            ? Icon(FontAwesomeIcons.clipboard, size: 30, color: grey.withOpacity(.8))
                                            : Stack(
                                                alignment: AlignmentDirectional.center,
                                                children: <Widget>[
                                                  Icon(FontAwesomeIcons.certificate, size: 25, color: green.withOpacity(.4)),
                                                  const Icon(FontAwesomeIcons.check, size: 16, color: green),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            const CustomizedText(text: "Channel Logo", color: white, fontSize: 16)
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return Row(
                            children: <Widget>[
                              for (String type in _types)
                                GestureDetector(
                                  onTap: () {
                                    if (_type != type) {
                                      _(() => _type = type);
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: 500.ms,
                                    margin: const EdgeInsets.only(right: 12.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: _type == type ? blue : grey),
                                    child: CustomizedText(text: type, color: white, fontSize: 16),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(controller: _articleTitleController, maxLines: 2, decoration: const InputDecoration(hintText: "Article Title", border: OutlineInputBorder(borderSide: BorderSide(color: blue, width: .5))), validator: validator("article_title")),
                    const SizedBox(height: 20),
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.now().subtract(const Duration(days: 15)),
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 15)),
                              currentDate: DateTime.now(),
                            ).then((DateTime? date) {
                              if (date != null) {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((TimeOfDay? time) {
                                  if (time != null) {
                                    _(() {
                                      _date = date;
                                      _time = time;
                                    });
                                  }
                                });
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: 500.ms,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: .5, color: grey)),
                            child: CustomizedText(text: _date == null ? 'Tap to select a date' : 'Selected Date: ${formatDateTime(_date!, _time!)}', fontSize: 16),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return GestureDetector(
                          onTap: () async {
                            await Clipboard.getData(Clipboard.kTextPlain).then((ClipboardData? value) {
                              if (value != null) {
                                if (value.text != null) {
                                  _(() => _linkOfArticle = value.text!);
                                  showToast(text: "Article URL pasted successfully from the clipboard", color: green.withOpacity(.3));
                                }
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: 500.ms,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: .5, color: grey)),
                            child: _linkOfArticle.isEmpty
                                ? const CustomizedText(text: 'Paste the article url here', fontSize: 16)
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.clipboard, size: 25, color: grey.withOpacity(.8)),
                                      const SizedBox(width: 20),
                                      Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.certificate, size: 25, color: green.withOpacity(.4)),
                                          const Icon(FontAwesomeIcons.check, size: 16, color: green),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      const CustomizedText(text: 'Copied', fontSize: 16),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(controller: _channelNameController, decoration: const InputDecoration(hintText: "Channel Name", border: OutlineInputBorder(borderSide: BorderSide(color: blue, width: .5))), validator: validator("channel_name")),
                    const SizedBox(height: 20),
                    TextFormField(controller: _authorController, decoration: const InputDecoration(hintText: "Author", border: OutlineInputBorder(borderSide: BorderSide(color: blue, width: .5))), validator: validator("author")),
                    const SizedBox(height: 20),
                    TextFormField(controller: _descriptionController, maxLines: 6, decoration: const InputDecoration(hintText: "Description", border: OutlineInputBorder(borderSide: BorderSide(color: blue, width: .5))), validator: validator("description")),
                    const SizedBox(height: 20),
                    TextFormField(controller: _contentController, maxLines: 6, decoration: const InputDecoration(hintText: "Content", border: OutlineInputBorder(borderSide: BorderSide(color: blue, width: .5))), validator: validator("content")),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (_date == null || _time == null) {
                            showToast(text: "Please pick the valid date and time of the article");
                          } else if (_articlePicture == noUser || _channelLogo == noUser) {
                            showToast(text: "You should provide the 2 pictures");
                          } else if (_formKey.currentState!.validate()) {
                            await FirebaseFirestore.instance.collection("articles").add(<String, dynamic>{
                              "author": _authorController.text.trim(),
                              "content": _contentController.text.trim(),
                              "description": "${_descriptionController.text.trim()}\n${_contentController.text.trim()}",
                              "publishedAt": DateTime(_date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute).toString(),
                              "source": <String, dynamic>{"id": null, "name": _channelNameController.text.trim()},
                              "sourceUrl": _channelLogo,
                              "title": _articleTitleController.text.trim(),
                              "topic": _type,
                              "url": _linkOfArticle,
                              "urlToImage": _articlePicture,
                            });
                            showToast(text: "Article added successfully");
                            _authorController.clear();
                            _contentController.clear();
                            _descriptionController.clear();
                            _articleTitleController.clear();
                            _channelNameController.clear();
                          } else {
                            Fluttertoast.showToast(msg: "Verify fields");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                          width: MediaQuery.of(context).size.width * .7,
                          child: const Center(child: CustomizedText(text: "Create Article", fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
