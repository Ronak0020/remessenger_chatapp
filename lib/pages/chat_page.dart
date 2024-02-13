import "package:cloud_firestore/cloud_firestore.dart";
import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import "package:remessenger/components/chat_bubble.dart";
import "package:remessenger/components/loading_circle.dart";
import "package:remessenger/components/text_field.dart";
import "package:remessenger/services/auth/auth_service.dart";
import "package:remessenger/services/chat/chat_services.dart";

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const ChatPage({super.key, required this.data});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => {scrollDown()});
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.data['uid'], _messageController.text);
      _messageController.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            // all messages
            Expanded(
              child: _buildMessageList(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: MyTextField(
                  focusNode: myFocusNode,
                  obscure: false,
                  hintText: 'Enter Message',
                  controller: _messageController,
                  maxLines: 10,
                )),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.secondary),
                  child: IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(FluentIcons.send_16_regular),
                  ),
                )
              ],
            )
            // input field and send button
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderID, widget.data['uid']),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleLoading();
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((e) => _buildMessageListItem(context, e, senderID))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageListItem(context, DocumentSnapshot doc, String senderID) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == senderID;

    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(data['senderID'])
                    // .where('uid',
                    //     isEqualTo:
                    //         widget._authService.getCurrentUser()!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleLoading();
                  }
            
                  if (!snapshot.hasData) {
                    return Text(
                      'Something went wrong...',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,),
                    );
                  }
                  var document = snapshot.data!.data();
                  return Text(
                    document?['name'],
                    style: TextStyle(
                        color: isCurrentUser
                            ? Theme.of(context).highlightColor
                            : Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold),
                  );
                }),
          ),
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser)
        ],
      ),
    );
    // return Text(data['message']);
  }
}
