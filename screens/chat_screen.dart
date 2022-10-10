import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
late User SignedInUser;

class ChatScreen extends StatefulWidget {
  static const String ScreenRoute = 'chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messages;

  void getCurrentUser() {
    final getUser = _auth.currentUser;

    if (getUser != null) {
      SignedInUser = getUser;

      print(getUser.email);
    }
  }

  // void getMessages() async {
  //   final chat_message = await _firestore
  //       .collection('messages')
  //       .get(); //This will retrieve all data from database

  //   for (var iMessage in chat_message.docs) {
  //     print(iMessage);
  //   }
  // }

  void getSnapshotsMessages() async {
    //Retrieve the data immediately (no need to update)
    await for (var i in _firestore.collection('messages').snapshots()) {
      for (var j in i.docs) {
        print(j.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('imgs/logo.png', height: 25),
            SizedBox(width: 10),
            Text('MessageMe')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();

              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  List<MessageLine> messageList = [];

                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    );
                  }

                  final message = snapshot.data!.docs;

                  for (var item in message) {
                    final messageText = item.get('text');
                    final messageSender = item.get('sender');
                    final currentUser = SignedInUser.email;
                    final bool isMe2;
                    final messageWidget = MessageLine(
                      sender: messageSender,
                      text: messageText,
                      isMe: currentUser == messageSender, //true
                    );
                    messageList.add(messageWidget);
                  }

                  return Expanded(
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: messageList,
                        ),
                      ],
                    ),
                  );
                }),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        messages = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textController.clear();
                      _firestore.collection('messages').add({
                        "sender": SignedInUser.email,
                        "text": messages,
                      });
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// just for organization
class MessageLine extends StatelessWidget {
  final String? text;
  final String? sender;
  final bool isMe;
  const MessageLine({this.sender, this.text, required this.isMe, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(color: Colors.orange),
          ),
          SizedBox(height: 10),
          Material(
            elevation: 5,
            color: isMe ? Colors.blue[800] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 17,
                    color: isMe ? Colors.white : Colors.black,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
