import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_gpt_api/app/chat_gpt.dart';
import 'package:chat_gpt_api/app/model/data_model/completion/completion.dart';
import 'package:chat_gpt_api/app/model/data_model/completion/completion_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SmartChatBot extends StatefulWidget {
  const SmartChatBot({super.key});

  @override
  State<SmartChatBot> createState() => _SmartChatBotState();
}

class _SmartChatBotState extends State<SmartChatBot> {
  final TextEditingController _messagesController = TextEditingController();
  bool _userWriting = false;
  bool _botWriting = false;
  final ChatGPT _smartChatBot = ChatGPT.builder(token: apiKey);
  final GlobalKey _dancingDotsKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    _messagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: darkBlue,
        appBar: AppBar(
          backgroundColor: dark,
          title: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: dark,
                radius: 15,
                child: CachedNetworkImage(
                  imageUrl: chatBot,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) => const Center(child: Icon(FontAwesomeIcons.user, color: grey, size: 15)),
                ),
              ),
              const SizedBox(width: 10),
              const CustomizedText(text: "Quark", fontSize: 16, color: blue, fontWeight: FontWeight.bold),
            ],
          ),
          actions: <Widget>[
            StatefulBuilder(
              key: _dancingDotsKey,
              builder: (BuildContext context, void Function(void Function()) _) {
                return _botWriting ? const DancingDots() : const SizedBox();
              },
            ),
          ],
          leading: CustomIcon(
            func: () {
              Navigator.pop(context);
            },
            icon: FontAwesomeIcons.chevronLeft,
          ),
        ),
        body: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("quark").doc(FirebaseAuth.instance.currentUser!.uid).collection("messages").orderBy("timestamp").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  final List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
                  return messages.isEmpty
                      ? Expanded(child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.noMessagesYet, color: blue, fontSize: 20, fontWeight: FontWeight.bold)))
                      : Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
                                _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: 100.ms, curve: Curves.linear);
                              });
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: messages[index].get("me") ? MainAxisAlignment.end : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (!messages[index].get("me"))
                                    Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: CircleAvatar(
                                        backgroundColor: grey.withOpacity(.2),
                                        radius: 15,
                                        child: CachedNetworkImage(
                                          imageUrl: chatBot,
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) => const Center(child: Icon(FontAwesomeIcons.user, color: grey, size: 15)),
                                        ),
                                      ),
                                    ),
                                  if (!messages[index].get("me")) const SizedBox(width: 2),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * .7,
                                    child: MessageTile(
                                      me: messages[index].get("me"),
                                      message: messages[index].get("message"),
                                      rewrite: index == messages.length - 1 ? true : false,
                                      date: messages[index].get("timestamp").toDate(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return const ListTileShimmer();
                      },
                    ),
                  );
                } else {
                  return ErrorRoom(error: snapshot.error.toString());
                }
              },
            ),
            KeyboardVisibilityBuilder(
              builder: (BuildContext context, bool isKeyboardVisible) => AnimatedContainer(
                duration: 500.ms,
                height: isKeyboardVisible ? 50 : 90,
                decoration: const BoxDecoration(color: dark, borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35))),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                width: MediaQuery.of(context).size.width,
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setS) {
                    return Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(FontAwesomeIcons.keyboard, color: grey, size: 25),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: IgnorePointer(
                              ignoring: _botWriting,
                              child: TextField(
                                controller: _messagesController,
                                onChanged: (String text) {
                                  setS(() {
                                    _userWriting = text.isNotEmpty;
                                  });
                                },
                                decoration: const InputDecoration.collapsed(hintText: 'Type a message'),
                              ),
                            ),
                          ),
                          if (_userWriting) const SizedBox(width: 10),
                          if (_userWriting)
                            CustomIcon(
                              func: () async {
                                if (_messagesController.text.trim().isNotEmpty) {
                                  setS(() {
                                    _dancingDotsKey.currentState!.setState(() {
                                      _botWriting = true;
                                    });
                                    _userWriting = false;
                                  });
                                  String text = _messagesController.text.trim();

                                  _messagesController.clear();
                                  FocusScope.of(context).unfocus();
                                  await FirebaseFirestore.instance.collection("quark").doc(FirebaseAuth.instance.currentUser!.uid).collection("messages").doc().set({
                                    "message": text,
                                    "timestamp": Timestamp.now(),
                                    "me": true,
                                  }).then((void value) async {
                                    playNote("replying.mp3");
                                    await _smartChatBot.textCompletion(request: CompletionRequest(maxTokens: 1024, prompt: text)).then((Completion? value) async {
                                      setS(() {
                                        _dancingDotsKey.currentState!.setState(() {
                                          _botWriting = false;
                                        });
                                      });
                                      await FirebaseFirestore.instance.collection("quark").doc(FirebaseAuth.instance.currentUser!.uid).collection("messages").doc().set({
                                        "message": value!.choices!.first.text!.trim(),
                                        "timestamp": Timestamp.now(),
                                        "me": false,
                                      });
                                    });
                                  });
                                }
                              },
                              icon: Icons.send,
                              size: 25,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.me, required this.message, required this.rewrite, required this.date});
  final bool me;
  final String message;
  final bool rewrite;
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      shadowColor: transparent,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      clipper: ChatBubbleClipper1(type: me ? BubbleType.sendBubble : BubbleType.receiverBubble),
      margin: const EdgeInsets.only(top: 20),
      backGroundColor: me ? dark : dark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!me) const CustomizedText(text: "Quark", fontSize: 16, color: blue, fontWeight: FontWeight.bold),
          rewrite && !me
              ? AnimatedTextKit(
                  repeatForever: false,
                  totalRepeatCount: 1,
                  animatedTexts: <AnimatedText>[TypewriterAnimatedText(message, speed: 50.ms, textStyle: GoogleFonts.roboto(fontSize: 13, color: white))],
                )
              : CustomizedText(text: message, fontSize: 16, color: white),
          const SizedBox(height: 5),
          Row(
            children: <Widget>[
              const Spacer(),
              CustomizedText(text: getTimeFromDate(date), fontSize: 12, color: blue),
            ],
          )
        ],
      ),
    );
  }
}

class DancingDots extends StatelessWidget {
  const DancingDots({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(radius: 2, backgroundColor: white.withOpacity(.7)).animate(target: 1, onComplete: (AnimationController controller) => controller.repeat(reverse: true)).moveY(duration: 600.ms, begin: 0, end: -3),
          CircleAvatar(radius: 2, backgroundColor: white.withOpacity(.7)).animate(target: 1, onComplete: (AnimationController controller) => controller.repeat(reverse: true)).moveY(duration: 600.ms, begin: 0, end: -3, delay: 200.ms),
          CircleAvatar(radius: 2, backgroundColor: white.withOpacity(.7)).animate(target: 1, onComplete: (AnimationController controller) => controller.repeat(reverse: true)).moveY(duration: 600.ms, begin: 0, end: -3, delay: 400.ms),
        ],
      ),
    );
  }
}
