import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_care/screens/chat_room.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
        title: CustomizedText(text: "Chat Room", fontSize: 18, color: blue, fontWeight: FontWeight.bold),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, color: blue, size: 20)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: <Widget>[const Spacer(), CustomPaint(painter: HalfCirclePainter(), child: const SizedBox(width: 60, height: 60))]),
            Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), const SizedBox(width: 50)]),
            Row(children: <Widget>[const Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), const SizedBox(width: 30)]),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: <Widget>[
                            const CircleAvatar(
                              radius: 25,
                              backgroundImage: CachedNetworkImageProvider('https://picsum.photos/200'),
                            ),
                            CircleAvatar(radius: 5, backgroundColor: green),
                          ],
                        ),
                        const SizedBox(height: 5),
                        CustomizedText(text: 'User $index', fontSize: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ChatRoom())),
                    contentPadding: EdgeInsets.zero,
                    leading: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: <Widget>[
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: CachedNetworkImageProvider('https://picsum.photos/201'),
                        ),
                        CircleAvatar(radius: 5, backgroundColor: green),
                      ],
                    ),
                    title: CustomizedText(text: 'User $index', fontSize: 16, fontWeight: FontWeight.bold),
                    subtitle: CustomizedText(text: 'Last message from User $index', fontSize: 14),
                    trailing: const CustomizedText(text: '11:30 AM', fontSize: 14),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
