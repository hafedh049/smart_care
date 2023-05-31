// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
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
  final GlobalKey _chatKey = GlobalKey();
  List<types.Message> _messages = <types.Message>[];
  late final types.User _user;
  String _user1ID = '';
  String _user2ID = '';
  List<String> _usersIDS = <String>[];
  String _chatId = "";
  @override
  void initState() {
    super.initState();
    _user1ID = me["uid"];
    _user2ID = widget.talkTo["uid"];
    _usersIDS = <String>[_user1ID, _user2ID];
    _usersIDS.sort();
    _chatId = '${_usersIDS[0]}_${_usersIDS[1]}';
    _user = types.User(id: me["uid"], firstName: me["name"].split(" ").length == 2 ? me["name"].split(" ")[0] : me["name"], imageUrl: me["image_url"], lastName: me["name"].split(" ").length == 2 ? me["name"].split(" ")[1] : "");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: IconButton(highlightColor: transparent, splashColor: transparent, focusColor: transparent, onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesomeIcons.chevronLeft, size: 15)),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(radius: 20, backgroundImage: widget.talkTo["image_url"] == noUser ? null : CachedNetworkImageProvider(widget.talkTo["image_url"]), backgroundColor: grey.withOpacity(.2), child: widget.talkTo["image_url"] != noUser ? null : const Icon(FontAwesomeIcons.user, color: grey, size: 15)),
              const SizedBox(width: 5),
              Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[CustomizedText(text: widget.talkTo["name"], fontSize: 16, fontWeight: FontWeight.bold, color: themeMode == 1 ? white : black), CustomizedText(text: widget.talkTo["status"] ? "Online" : "Offline", fontSize: 14, color: blue)])),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("chats").doc(_chatId).collection("messages").orderBy("createdAt", descending: true).limit(10).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data == null ? <QueryDocumentSnapshot<Map<String, dynamic>>>[] : snapshot.data!.docs;
              _messages = data.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => types.Message.fromJson(e.data())).toList();
              return StatefulBuilder(
                  key: _chatKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return Chat(
                      theme: themeMode == 1 ? const DarkChatTheme(messageBorderRadius: 10, inputTextDecoration: InputDecoration(fillColor: transparent)) : const DefaultChatTheme(messageBorderRadius: 10, inputTextDecoration: InputDecoration(fillColor: transparent)),
                      scrollPhysics: const BouncingScrollPhysics(),
                      isLastPage: true,
                      useTopSafeAreaInset: true,
                      bubbleRtlAlignment: BubbleRtlAlignment.left,
                      messages: _messages,
                      onAttachmentPressed: _handleAttachmentPressed,
                      onMessageTap: _handleMessageTap,
                      onSendPressed: _handleSendPressed,
                      showUserAvatars: true,
                      showUserNames: true,
                      onAvatarTap: (types.User user) => user.metadata!["image_url"] == null ? null : showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: CachedNetworkImage(imageUrl: user.metadata!["image_url"]))),
                      user: _user,
                      textMessageOptions: TextMessageOptions(isTextSelectable: true, onLinkPressed: (String link) async => await launchUrlString(link), openOnPreviewImageTap: true, openOnPreviewTitleTap: true),
                    );
                  });
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            } else {
              return ErrorRoom(error: snapshot.error.toString());
            }
          },
        ),
      ),
    );
  }

  void _handleAttachmentPressed() async {
    await showModalBottomSheet<void>(
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
                icon: const Icon(FontAwesomeIcons.photoFilm, size: 20),
              ),
              Container(color: Colors.grey, width: .5, height: 50),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                icon: const Icon(FontAwesomeIcons.fileImport, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowCompression: true, allowedExtensions: const <String>["pdf", "txt", "doc", "xml", "csv"]);
    if (result != null && result.files.single.path != null) {
      final Timestamp now = Timestamp.now();
      final Uint8List bytes = await File(result.files.first.path!).readAsBytes();
      showToast(text: 'uploading'.tr);

      await FirebaseStorage.instance.ref().child('chats_media/$_chatId/${now.toString()}').putData(bytes).then(
        (TaskSnapshot ref) async {
          final String uri = await ref.ref.getDownloadURL();
          await FirebaseFirestore.instance.collection("chats").doc(_chatId).collection("messages").add(types.FileMessage(author: _user, id: now.toString(), name: result.files.first.name, size: result.files.first.size, uri: uri, createdAt: now.millisecondsSinceEpoch).toJson());
          await FirebaseFirestore.instance.collection("chats").doc(_chatId).set(<String, dynamic>{
            "last_message": {"message": "An image was sent", "timestamp": now},
            "participants": <String>[_user1ID, _user2ID],
            "names": <String>[me["name"], widget.talkTo["name"]],
          });
          if (widget.talkTo["token"].isNotEmpty) {
            sendPushNotificationFCM(token: widget.talkTo["token"], username: me["name"], message: "An image was sent");
          }
        },
      );
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(imageQuality: 100, source: ImageSource.gallery);
    if (result != null) {
      final Uint8List bytes = await result.readAsBytes();
      final Timestamp now = Timestamp.now();
      showToast(text: 'uploading'.tr);
      await FirebaseStorage.instance.ref().child('chats_media/$_chatId/${now.toString()}').putData(bytes).then(
        (TaskSnapshot ref) async {
          final String uri = await ref.ref.getDownloadURL();
          await FirebaseFirestore.instance.collection("chats").doc(_chatId).collection("messages").add(types.ImageMessage(author: _user, id: now.toString(), name: result.name, size: await result.length(), uri: uri, createdAt: now.millisecondsSinceEpoch).toJson());
          await FirebaseFirestore.instance.collection("chats").doc(_chatId).set(<String, dynamic>{
            "last_message": {"message": "An image was sent", "timestamp": now},
            "participants": <String>[_user1ID, _user2ID],
            "names": <String>[me["name"], widget.talkTo["name"]],
          });
          if (widget.talkTo["token"].isNotEmpty) {
            sendPushNotificationFCM(token: widget.talkTo["token"], username: me["name"], message: "An image was sent");
          }
        },
      );
    }
  }

  void _handleSendPressed(types.PartialText message) async {
    final Timestamp now = Timestamp.now();
    await FirebaseFirestore.instance.collection("chats").doc(_chatId).collection("messages").add(types.TextMessage.fromPartial(author: _user, id: now.toString(), partialText: message, createdAt: now.millisecondsSinceEpoch).toJson());
    await FirebaseFirestore.instance.collection("chats").doc(_chatId).set(<String, dynamic>{
      "last_message": {"message": message.text, "timestamp": now},
      "participants": _usersIDS,
      "names": <String>[me["name"], widget.talkTo["name"]],
    });
    if (widget.talkTo["token"].isNotEmpty) {
      sendPushNotificationFCM(token: widget.talkTo["token"], username: me["name"], message: message.text);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      String localPath = message.uri;
      if (message.uri.startsWith('http')) {
        try {
          final int index = _messages.indexWhere((element) => element.id == message.id);
          final types.Message updatedMessage = (_messages[index] as types.FileMessage).copyWith(isLoading: true);

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
      showToast(text: 'openingfile'.tr);
      await OpenFilex.open(localPath);
    }
  }
}
