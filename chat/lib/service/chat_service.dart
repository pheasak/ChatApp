import 'package:chat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatSerivce {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      String reciverID, String message, String username) async {
    //get current user info
    final String currentuserId = auth.currentUser!.uid;
    final String currentemail = auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message msm = Message(
        username: username,
        message: message,
        reccieverid: reciverID,
        senderId: currentuserId,
        senderemail: currentemail,
        timestamp: timestamp);
    //construct chat room id from current user id and recceiver id(sorted to ensure unipueness)
    List<String> ids = [currentuserId, reciverID];
    ids.sort();
    String chatroomid = ids.join("_");
    // add new message to database
    await firestore
        .collection('chats_room')
        .doc(chatroomid)
        .collection('message')
        .add(msm.tomap());
    // await firestore
    //     .collection('users')
    //     .doc(auth.currentUser!.uid)
    //     .collection('friends')
    //     .doc()
    //     .collection('chat_room')
    //     .doc(chatroomid)
    //     .collection('message')
    //     .add(msm.tomap());
  }

  //Get message
  Stream<QuerySnapshot> getmessage(String userid, String otheruserid) {
    List<String> ids = [userid, otheruserid];
    ids.sort();
    String chatRoomid = ids.join("_");
    return firestore
        .collection('chats_room')
        .doc(chatRoomid)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
    // return firestore
    //     .collection('users')
    //     .doc(auth.currentUser!.uid)
    //     .collection('friends')
    //     .doc(otheruserid)
    //     .collection('chat_room')
    //     .doc(chatRoomid)
    //     .collection('message')
    //     .orderBy('timestamp', descending: false)
    //     .snapshots();
  }

  Future<void> deletechat(
      String currentuserId, String reciverID, DocumentSnapshot document) async {
    List<String> ids = [currentuserId, reciverID];
    ids.sort();
    String chatroomid = ids.join("_");
    await firestore
        .collection('chat_room')
        .doc(chatroomid)
        .collection('message')
        .doc(document.id)
        .delete();
  }
}
