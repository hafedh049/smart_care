import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';

class SmartChatBot extends StatefulWidget {
  const SmartChatBot({super.key});

  @override
  State<SmartChatBot> createState() => _SmartChatBotState();
}

class _SmartChatBotState extends State<SmartChatBot> {
  final TextEditingController _messagesController = TextEditingController();
  bool _userWriting = false;
  bool _botWriting = false;
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              CircleAvatar(backgroundColor: dark, radius: 15, child: CachedNetworkImage(imageUrl: chatBot, fit: BoxFit.cover, placeholder: (BuildContext context, String url) => const Center(child: Icon(FontAwesomeIcons.user, size: 15)))),
              const SizedBox(width: 10),
              const CustomizedText(text: "Quark", fontSize: 16, color: blue, fontWeight: FontWeight.bold),
            ],
          ),
          actions: <Widget>[StatefulBuilder(key: _dancingDotsKey, builder: (BuildContext context, void Function(void Function()) _) => _botWriting ? const DancingDots() : const SizedBox())],
          leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 20, height: 20, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.chevronLeft, size: 15))),
        ),
        body: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("quark").doc(FirebaseAuth.instance.currentUser!.uid).collection("messages").orderBy("timestamp").limit(10).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  final List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
                  return messages.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                LottieBuilder.asset("assets/lottie/notFound.json"),
                                CustomizedText(text: 'noMessagesYet'.tr, color: blue, fontSize: 20, fontWeight: FontWeight.bold),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) => _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: 100.ms, curve: Curves.linear));
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
                                        child: CachedNetworkImage(imageUrl: chatBot, fit: BoxFit.cover, placeholder: (BuildContext context, String url) => const Center(child: Icon(FontAwesomeIcons.user, color: grey, size: 15))),
                                      ),
                                    ),
                                  if (!messages[index].get("me")) const SizedBox(width: 2),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * .7,
                                    child: MessageTile(me: messages[index].get("me"), message: messages[index].get("message"), rewrite: index == messages.length - 1 ? true : false, date: messages[index].get("timestamp").toDate()),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                decoration: BoxDecoration(color: white.withOpacity(.3), borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35))),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                width: MediaQuery.of(context).size.width,
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setS) {
                    return Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Row(
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.only(left: 4), child: Icon(FontAwesomeIcons.keyboard, color: grey, size: 25)),
                          const SizedBox(width: 10),
                          Flexible(child: IgnorePointer(ignoring: _botWriting, child: TextField(controller: _messagesController, onChanged: (String text) => setS(() => _userWriting = text.isNotEmpty), decoration: InputDecoration.collapsed(hintText: 'Type a message'.tr)))),
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
                                  await FirebaseFirestore.instance.collection("quark").doc(FirebaseAuth.instance.currentUser!.uid).collection("messages").doc().set({"message": text, "timestamp": Timestamp.now(), "me": true}).then((void value) async {
                                    final String req = await getChatResponse(text);
                                    setS(() => _dancingDotsKey.currentState!.setState(() => _botWriting = false));
                                    await FirebaseFirestore.instance.collection("quark").doc(FirebaseAuth.instance.currentUser!.uid).collection("messages").doc().set({"message": req.trim(), "timestamp": Timestamp.now(), "me": false});
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      clipper: ChatBubbleClipper1(type: me ? BubbleType.sendBubble : BubbleType.receiverBubble),
      margin: const EdgeInsets.only(top: 20),
      backGroundColor: me ? dark : dark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!me) const CustomizedText(text: "Quark", fontSize: 16, color: blue, fontWeight: FontWeight.bold),
          rewrite && !me ? AnimatedTextKit(repeatForever: false, totalRepeatCount: 1, animatedTexts: <AnimatedText>[TypewriterAnimatedText(message, speed: 50.ms, textStyle: GoogleFonts.roboto(fontSize: 13))]) : CustomizedText(text: message, fontSize: 16),
          const SizedBox(height: 5),
          Row(children: <Widget>[const Spacer(), CustomizedText(text: getTimeFromDate(date), fontSize: 12, color: blue)])
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
      margin: const EdgeInsets.only(right: 8),
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
