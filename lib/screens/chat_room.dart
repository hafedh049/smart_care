import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/stuff/smart_theme.dart';

import '../stuff/globals.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ScrollController _scrollController = ScrollController();
  late final ChatController _chatController;
  final ChatUser _sender = ChatUser(id: "1", name: "Hafedh");
  final ChatUser _receiver = ChatUser(id: "2", name: "Nourhene");
  final AppTheme _darkTheme = DarkTheme();

  @override
  void initState() {
    _chatController = ChatController(initialMessageList: <Message>[], scrollController: _scrollController);
    super.initState();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: ChatView(
                appBar: ChatViewAppBar(
                  userStatusTextStyle: GoogleFonts.roboto(color: blue),
                  backGroundColor: _darkTheme.appBarColor,
                  elevation: _darkTheme.elevation,
                  backArrowColor: _darkTheme.backArrowColor,
                  userStatus: "Actif",
                  actions: const <Widget>[],
                  profilePicture: noUser,
                  titleTextStyle: GoogleFonts.roboto(color: _darkTheme.appBarTitleTextStyle, fontSize: 16, fontWeight: FontWeight.bold),
                  title: "Hafedh Gunichi",
                  onBackPress: () {},
                ),
                chatBubbleConfig: ChatBubbleConfiguration(
                  inComingChatBubbleConfig: ChatBubble(
                    borderRadius: BorderRadius.circular(15),
                    color: _darkTheme.inComingChatBubbleColor,
                    linkPreviewConfig: LinkPreviewConfiguration(
                      backgroundColor: _darkTheme.linkPreviewIncomingChatColor,
                      bodyStyle: _darkTheme.incomingChatLinkBodyStyle,
                      linkStyle: _darkTheme.linkPreviewIncomingTitleStyle,
                      borderRadius: 15,
                      loadingColor: blue,
                      titleStyle: _darkTheme.linkPreviewIncomingTitleStyle,
                    ),
                  ),
                  longPressAnimationDuration: 200.ms,
                  onDoubleTap: (Message message) {},
                  outgoingChatBubbleConfig: ChatBubble(
                    borderRadius: BorderRadius.circular(15),
                    color: _darkTheme.outgoingChatBubbleColor,
                    linkPreviewConfig: LinkPreviewConfiguration(
                      backgroundColor: _darkTheme.linkPreviewOutgoingChatColor,
                      bodyStyle: _darkTheme.outgoingChatLinkBodyStyle,
                      linkStyle: _darkTheme.linkPreviewOutgoingTitleStyle,
                      borderRadius: 15,
                      loadingColor: blue,
                      titleStyle: _darkTheme.outgoingChatLinkTitleStyle,
                    ),
                  ),
                ),
                repliedMessageConfig: RepliedMessageConfiguration(
                  backgroundColor: _darkTheme.repliedMessageColor,
                  borderRadius: BorderRadius.circular(15),
                  opacity: .3,
                  repliedImageMessageBorderRadius: BorderRadius.circular(15),
                  verticalBarColor: blue,
                  verticalBarWidth: 1,
                ),
                replyPopupConfig: ReplyPopupConfiguration(
                  backgroundColor: _darkTheme.replyPopupColor,
                  topBorderColor: _darkTheme.replyPopupTopBorderColor,
                  buttonTextStyle: GoogleFonts.roboto(color: _darkTheme.replyPopupButtonColor, fontSize: 16, fontWeight: FontWeight.bold),
                  onMoreTap: () {},
                  onReplyTap: (Message message) {},
                  onUnsendTap: (Message message) {},
                  onReportTap: () {},
                ),
                sendMessageConfig: SendMessageConfiguration(
                  closeIconColor: _darkTheme.closeIconColor,
                  defaultSendButtonColor: _darkTheme.sendButtonColor,
                  imagePickerIconsConfig: ImagePickerIconsConfiguration(
                    cameraIconColor: _darkTheme.cameraIconColor,
                    cameraImagePickerIcon: const Icon(FontAwesomeIcons.camera, size: 15),
                    galleryIconColor: _darkTheme.galleryIconColor,
                    galleryImagePickerIcon: const Icon(FontAwesomeIcons.image, size: 15),
                    onImageSelected: (String emoji, String messageId) {
                      print(MessageType.values);
                      _chatController.addMessage(
                        Message(
                          messageType: MessageType.image,
                          createdAt: DateTime.now(),
                          sendBy: _sender.name,
                          message: emoji,
                          id: messageId,
                        ),
                      );
                    },
                  ),
                  replyDialogColor: _darkTheme.replyDialogColor,
                  replyMessageColor: _darkTheme.replyMessageColor,
                  replyTitleColor: _darkTheme.replyTitleColor,
                  textFieldBackgroundColor: _darkTheme.textFieldBackgroundColor,
                  textFieldConfig: TextFieldConfiguration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    hintText: "Send Message ...",
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    textStyle: GoogleFonts.roboto(color: _darkTheme.textFieldTextColor),
                    maxLines: 3,
                  ),
                ),
                showReceiverProfileCircle: true,
                showTypingIndicator: true,
                swipeToReplyConfig: SwipeToReplyConfiguration(
                  animationDuration: 100.ms,
                  onLeftSwipe: (String message, String sendBy) {},
                  replyIconColor: _darkTheme.replyMicIconColor,
                  onRightSwipe: (String message, String sendBy) {},
                ),
                typeIndicatorConfig: TypeIndicatorConfiguration(
                  flashingCircleBrightColor: white,
                  flashingCircleDarkColor: grey,
                  indicatorSize: 4,
                  indicatorSpacing: 2,
                ),
                enablePagination: true,
                isLastPage: true,
                loadMoreData: () async {},
                loadingWidget: CircularProgressIndicator(color: blue),
                messageConfig: MessageConfiguration(
                  emojiMessageConfig: EmojiMessageConfiguration(padding: const EdgeInsets.all(8.0)),
                  imageMessageConfig: ImageMessageConfiguration(
                    borderRadius: BorderRadius.circular(5),
                    height: 220,
                    width: 120,
                    shareIconConfig: ShareIconConfiguration(
                      defaultIconBackgroundColor: _darkTheme.shareIconBackgroundColor,
                      defaultIconColor: _darkTheme.shareIconColor,
                      icon: const Icon(FontAwesomeIcons.share, size: 20),
                      onPressed: (String url) {},
                    ),
                    onTap: (String url) {},
                  ),
                  messageReactionConfig: MessageReactionConfiguration(
                    backgroundColor: _darkTheme.messageReactionBackGroundColor,
                    borderColor: _darkTheme.messageReactionBorderColor,
                    borderRadius: BorderRadius.circular(5),
                    borderWidth: .5,
                    reactionSize: 20,
                  ),
                ),
                onSendTap: (String message, ReplyMessage replyMessage) {
                  _chatController.addMessage(Message(message: message, createdAt: DateTime.now(), sendBy: _sender.name));
                },
                profileCircleConfig: ProfileCircleConfiguration(
                  bottomPadding: 0.0,
                  circleRadius: 20,
                  profileImageUrl: noUser,
                ),
                reactionPopupConfig: ReactionPopupConfiguration(
                  animationDuration: 500.ms,
                  backgroundColor: _darkTheme.reactionPopupColor,
                  emojiConfig: EmojiConfiguration(
                    size: 15,
                  ),
                  glassMorphismConfig: GlassMorphismConfiguration(
                    backgroundColor: grey,
                    borderColor: transparent,
                    borderRadius: 5,
                    strokeWidth: 0,
                  ),
                  onEmojiTap: (String emoji, String messageId) {},
                  showGlassMorphismEffect: true,
                ),
                chatBackgroundConfig: ChatBackgroundConfiguration(
                  backgroundColor: _darkTheme.backgroundColor,
                  backgroundImage: null,
                  horizontalDragToShowMessageTime: true,
                  messageTimeIconColor: blue,
                  messageTimeTextStyle: GoogleFonts.roboto(color: white),
                  sortEnable: true,
                  loadingWidget: CircularProgressIndicator(color: blue),
                  defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
                    padding: const EdgeInsets.all(8.0),
                    textStyle: GoogleFonts.roboto(color: white),
                  ),
                ),
                sender: _sender,
                receiver: _receiver,
                chatController: _chatController,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
