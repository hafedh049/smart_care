// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../stuff/functions.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.talkTo});
  final Map<String, dynamic> talkTo;
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<types.Message> _messages = [];
  late final types.User _user;
  late final types.User _remoteUser;
  @override
  void initState() {
    super.initState();
    _user = types.User(
      id: FirebaseAuth.instance.currentUser!.uid,
      createdAt: me["account_creation_date"].toDate().millisecond,
      firstName: me["name"].split(" ").length == 2 ? me["name"].split(" ")[0] : me["name"],
      imageUrl: me["image_url"],
      lastName: me["name"].split(" ").length == 2 ? me["name"].split(" ")[1] : "",
    );
    _remoteUser = types.User(
      id: widget.talkTo["uid"],
      createdAt: widget.talkTo["account_creation_date"].toDate().millisecond,
      firstName: widget.talkTo["name"].split(" ").length == 2 ? me["name"].split(" ")[0] : me["name"],
      imageUrl: widget.talkTo["image_url"],
      lastName: widget.talkTo["name"].split(" ").length == 2 ? me["name"].split(" ")[1] : "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (play == 1) {
          playNote("tap.wav");
        }
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
          centerTitle: false,
          leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(FontAwesomeIcons.chevronLeft, size: 15, color: white),
          ),
          actions: [
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.video, size: 15, color: white),
            ),
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.phone, size: 15, color: white),
            ),
          ],
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.talkTo["image_url"] == noUser ? null : CachedNetworkImageProvider(widget.talkTo["image_url"]),
                backgroundColor: grey.withOpacity(.2),
                child: widget.talkTo["image_url"] != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 15),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomizedText(text: widget.talkTo["name"], fontSize: 16, fontWeight: FontWeight.bold, color: white),
                  CustomizedText(text: widget.talkTo["status"] ? "Online" : "Offline", fontSize: 14, color: blue),
                ],
              ),
            ],
          ),
          backgroundColor: const Color(0xff2b2250),
        ),
        backgroundColor: const Color(0xff1f1c38),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").doc(widget.talkTo["uid"]).collection("content").orderBy("created_at", descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data == null ? <QueryDocumentSnapshot<Map<String, dynamic>>>[] : snapshot.data!.docs;
              _messages = data.map(
                (QueryDocumentSnapshot<Map<String, dynamic>> e) {
                  if ("audio" == e["type"]) {
                    return types.AudioMessage(
                      uri: e.get("uri"),
                      size: e.get("size") as num,
                      duration: e.get("duration").ms,
                      mimeType: e.get("mimetype"),
                      waveForm: <double>[for (int i = -100; i <= 100; i++) i / 100],
                      name: e.get("name"),
                      author: e.get("owner_id") == widget.talkTo["uid"] ? _remoteUser : _user,
                      id: e.get("message_id"),
                      createdAt: e.get("created_at").toDate().millisecond,
                      showStatus: true,
                      status: types.Status.delivered,
                      type: types.MessageType.audio,
                    );
                  } else if (e.get("type") == "custom") {
                    return types.CustomMessage(
                      author: e.get("owner_id") == widget.talkTo["uid"] ? _remoteUser : _user,
                      id: e.get("message_id"),
                      createdAt: e.get("created_at").toDate().millisecond,
                      showStatus: true,
                      status: types.Status.delivered,
                      type: types.MessageType.custom,
                    );
                  } else if (e.get("type") == "file") {
                    return types.FileMessage(
                      uri: e.get("file_uri"),
                      size: e.get("size") as num,
                      name: e.get("name"),
                      author: e.get("owner_id") == widget.talkTo["uid"] ? _remoteUser : _user,
                      id: e.get("file_id"),
                      createdAt: e.get("created_at").toDate().millisecond,
                      showStatus: true,
                      mimeType: e.get("mimeType"),
                      status: types.Status.delivered,
                      type: types.MessageType.file,
                    );
                  } else if (e.get("type") == "image") {
                    return types.ImageMessage(
                      uri: e.get("image_uri"),
                      size: e.get("size"),
                      height: 300,
                      width: 200,
                      name: e.get("name"),
                      author: e.get("owner_id") == widget.talkTo["uid"] ? _remoteUser : _user,
                      id: e.get("image_id"),
                      createdAt: e.get("created_at").toDate().millisecond,
                      showStatus: true,
                      status: types.Status.delivered,
                      type: types.MessageType.image,
                    );
                  } else if (e.get("type") == "system") {
                    return types.SystemMessage(
                      author: e.get("owner_id") == widget.talkTo["uid"] ? _remoteUser : _user,
                      id: e.get("message_id"),
                      text: e.get("message"),
                      createdAt: e.get("created_at").toDate().millisecond,
                      showStatus: true,
                      status: types.Status.delivered,
                      type: types.MessageType.system,
                    );
                  } else if (e.get("type") == "text") {
                    return types.TextMessage(
                      author: e.get("owner_id") == widget.talkTo["uid"] ? _remoteUser : _user,
                      id: e.get("message_id"),
                      text: e.get("message"),
                      createdAt: e.get("created_at").toDate().millisecond,
                      showStatus: true,
                      status: types.Status.delivered,
                      type: types.MessageType.text,
                    );
                  } else if (e.get("type") == "video") {
                    return types.VideoMessage(
                      uri: e.get("uri"),
                      size: e.get("size") as num,
                      height: 300,
                      width: 200,
                      name: e.get("name"),
                      author: e.get("owner_id") == widget.talkTo["uid"] ? _remoteUser : _user,
                      id: e.get("message_id"),
                      createdAt: e.get("created_at").toDate().millisecond,
                      showStatus: true,
                      status: types.Status.delivered,
                      type: types.MessageType.video,
                    );
                  } else {
                    return types.UnsupportedMessage(
                      author: e.get("owner_id") == widget.talkTo["uid"] ? _remoteUser : _user,
                      id: e.get("message_id"),
                      createdAt: e.get("create_at").toDate().millisecond,
                    );
                  }
                },
              ).toList();
              return Chat(
                scrollPhysics: const BouncingScrollPhysics(),
                isLastPage: true,
                theme: const DarkChatTheme(
                  messageInsetsVertical: 10,
                ),
                useTopSafeAreaInset: true, bubbleRtlAlignment: BubbleRtlAlignment.left,
                messages: _messages,
                onAttachmentPressed: _handleAttachmentPressed,
                onMessageTap: _handleMessageTap,
                onSendPressed: _handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                user: _user,
                textMessageOptions: TextMessageOptions(
                  isTextSelectable: true,
                  onLinkPressed: (String link) async {
                    await launchUrlString(link);
                  },
                  openOnPreviewImageTap: true,
                  openOnPreviewTitleTap: true,
                ),
                hideBackgroundOnEmojiMessages: false,
                inputOptions: InputOptions(
                  inputClearMode: InputClearMode.always,
                  onTextChanged: (String text) {},
                  onTextFieldTap: () {},
                  sendButtonVisibilityMode: SendButtonVisibilityMode.editing,
                  textEditingController: null,
                ),
                isAttachmentUploading: false, //true,
                onMessageVisibilityChanged: (types.Message message, bool visible) {},
                onMessageStatusTap: (BuildContext context, types.Message message) {},
                onMessageStatusLongPress: (BuildContext context, types.Message message) {},
                onMessageLongPress: (BuildContext context, types.Message message) {},
                onMessageDoubleTap: (BuildContext context, types.Message message) {},
                onBackgroundTap: () {},
                onAvatarTap: (types.User user) {},
                emojiEnlargementBehavior: EmojiEnlargementBehavior.multi,
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else {
              Fluttertoast.showToast(msg: snapshot.error.toString());
              return ErrorRoom(error: snapshot.error.toString());
            }
          },
        ),
      ),
    );
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                icon: const Icon(FontAwesomeIcons.photoFilm, color: white, size: 20),
              ),
              Container(color: Colors.grey, width: .5, height: 50),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                icon: const Icon(FontAwesomeIcons.fileImport, color: white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowCompression: true, allowedExtensions: const <String>["pdf", "txt", "doc", "xml", "csv"]);
    if (result != null && result.files.single.path != null) {
      Timestamp now = Timestamp.now();
      Uint8List bytes = await File(result.files.first.path!).readAsBytes();
      showToast("Uploading ...");
      await FirebaseStorage.instance.ref("chats/").child(now.toString()).putData(bytes).then(
        (TaskSnapshot ref) async {
          String uri = await ref.ref.getDownloadURL();
          await FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").doc(widget.talkTo["uid"]).collection("content").doc().set(
            {
              "owner_id": me["uid"],
              "file_uri": uri,
              "created_at": now,
              "file_id": now.toString(),
              "name": result.files.single.name,
              "size": bytes.length,
              "type": "file",
              "mimeType": lookupMimeType(result.files.single.path!),
            },
          ).then(
            (void value) async {
              await FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").doc(widget.talkTo["uid"]).set(
                {
                  "last_message": {"message": result.files.single.name, "timestamp": now},
                },
                SetOptions(merge: true),
              ).then(
                (void value) async {
                  await FirebaseFirestore.instance.collection("chats").doc(widget.talkTo["uid"]).collection("messages").doc(me["uid"]).collection("content").doc().set(
                    {
                      "owner_id": me["uid"],
                      "file_uri": uri,
                      "created_at": now,
                      "file_id": now.toString(),
                      "name": result.files.single.name,
                      "size": bytes.length,
                      "type": "file",
                      "mimeType": lookupMimeType(result.files.single.path!),
                    },
                  ).then(
                    (void value) async {
                      await FirebaseFirestore.instance.collection("chats").doc(widget.talkTo["uid"]).collection("messages").doc(me["uid"]).set(
                        {
                          "last_message": {"message": result.files.single.name, "timestamp": now},
                        },
                        SetOptions(merge: true),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 100,
      source: ImageSource.gallery,
    );
    if (result != null) {
      Uint8List bytes = await result.readAsBytes();
      Timestamp now = Timestamp.now();
      Fluttertoast.showToast(msg: "Uploading ...");
      await FirebaseStorage.instance.ref("chats_files/").child(now.toString()).putData(bytes).then(
        (TaskSnapshot ref) async {
          String uri = await ref.ref.getDownloadURL();
          await FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").doc(widget.talkTo["uid"]).collection("content").doc().set(
            {
              "owner_id": me["uid"],
              "image_uri": uri,
              "created_at": now,
              "image_id": now.toString(),
              "name": result.name,
              "size": bytes.length,
              "type": "image",
            },
          ).then(
            (void value) async {
              await FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").doc(widget.talkTo["uid"]).set(
                {
                  "last_message": {"message": result.name, "timestamp": now},
                },
                SetOptions(merge: true),
              ).then(
                (void value) async {
                  await FirebaseFirestore.instance.collection("chats").doc(widget.talkTo["uid"]).collection("messages").doc(me["uid"]).collection("content").doc().set(
                    {
                      "owner_id": me["uid"],
                      "image_uri": uri,
                      "created_at": now,
                      "image_id": now.toString(),
                      "name": result.name,
                      "size": bytes.length,
                      "type": "image",
                    },
                  ).then(
                    (void value) async {
                      await FirebaseFirestore.instance.collection("chats").doc(widget.talkTo["uid"]).collection("messages").doc(me["uid"]).set(
                        {
                          "last_message": {"message": result.name, "timestamp": now},
                        },
                        SetOptions(merge: true),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  void _handleSendPressed(types.PartialText message) async {
    Timestamp now = Timestamp.now();
    await FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").doc(widget.talkTo["uid"]).collection("content").doc().set(
      {
        "owner_id": me["uid"],
        "message_id": now.toString(),
        "message": message.text,
        "created_at": now,
        "type": "text",
      },
    ).then(
      (void value) async {
        await FirebaseFirestore.instance.collection("chats").doc(me["uid"]).collection("messages").doc(widget.talkTo["uid"]).set(
          {
            "last_message": {"message": message.text, "timestamp": now},
          },
          SetOptions(merge: true),
        ).then(
          (void value) async {
            await FirebaseFirestore.instance.collection("chats").doc(widget.talkTo["uid"]).collection("messages").doc(me["uid"]).collection("content").doc().set(
              {
                "owner_id": me["uid"],
                "message_id": now.toString(),
                "message": message.text,
                "created_at": now,
                "type": "text",
              },
            ).then(
              (void value) async {
                await FirebaseFirestore.instance.collection("chats").doc(widget.talkTo["uid"]).collection("messages").doc(me["uid"]).set(
                  {
                    "last_message": {"message": message.text, "timestamp": now},
                  },
                  SetOptions(merge: true),
                );
              },
            );
          },
        );
      },
    );
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;
      if (message.uri.startsWith('http')) {
        try {
          final int index = _messages.indexWhere((element) => element.id == message.id);
          final types.Message updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          _messages[index] = updatedMessage;

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          _messages[index] = updatedMessage;
        }
      }
      Fluttertoast.showToast(msg: "Opening file ...");
      await OpenFilex.open(localPath);
    }
  }
}
