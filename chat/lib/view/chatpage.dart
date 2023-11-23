import 'package:chat/service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  final String receiverUseremail;
  final String receiverUserId;
  final String username;
  ChatPage(
      {required this.receiverUserId,
      required this.username,
      required this.receiverUseremail,
      super.key});
  final TextEditingController messagecontrol = TextEditingController();
  final ChatSerivce chatSerivce = ChatSerivce();
  final FirebaseAuth auth = FirebaseAuth.instance;
  void sendmessage() async {
    await chatSerivce.sendMessage(
        receiverUserId, messagecontrol.text, username);

    messagecontrol.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 0, 61),
      appBar: AppBar(
        title: Text(username),
        elevation: 0,
      ),
      body: Column(
        children: [Expanded(child: _buildListmessage()), _buildmessageinput()],
      ),
    );
  }

  // input message
  Widget _buildmessageinput() {
    return Container(
      color: Colors.blue,
      child: Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.grey),
              child: TextField(
                // maxLength: 35,
                maxLines: null,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    hintText: 'Send message',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
                controller: messagecontrol,
              ),
            ),
          ),
        ),
        IconButton(onPressed: sendmessage, icon: Icon(Icons.send)),
      ]),
    );
  }

  // item message
  Widget _builditemmessage(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var aligment = (data['senderId'] == auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: aligment,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: (data['senderId'] == auth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          _username(data),
          GestureDetector(
            onLongPress: () {
              Get.bottomSheet(Container(
                height: 90,
                color: Colors.black,
                child: IconButton(
                    onPressed: () {
                      chatSerivce.deletechat(
                          receiverUserId, auth.currentUser!.uid, document);
                    },
                    icon: Icon(Icons.delete)),
              ));
            },
            child: Container(
                margin: EdgeInsets.only(
                    bottom: 10,
                    right:
                        (data['senderId'] == auth.currentUser!.uid) ? 0 : 100,
                    left:
                        (data['senderId'] == auth.currentUser!.uid) ? 100 : 0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: (data['senderId'] == auth.currentUser!.uid)
                        ? Colors.green
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(25)),
                child: Text(
                  data['message'],
                  textScaleFactor: 1.1,
                )),
          ),
        ],
      ),
    );
  }

  // List message
  Widget _buildListmessage() {
    return StreamBuilder(
      stream: chatSerivce.getmessage(receiverUserId, auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        }
        return ListView(
          physics: BouncingScrollPhysics(),
          children: snapshot.data!.docs
              .map((document) => _builditemmessage(document))
              .toList(),
        );
      },
    );
  }

  //builduser
  Widget _username(Map<String, dynamic> data) {
    return Text(
      (data['senderId'] == auth.currentUser!.uid) ? '' : username,
      style: TextStyle(color: Colors.white),
    );
  }
}
