import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderemail;
  final String reccieverid;
  final String message;
  final Timestamp timestamp;
  final String username;
  Message(
      {required this.username,
      required this.message,
      required this.reccieverid,
      required this.senderId,
      required this.senderemail,
      required this.timestamp});

  Map<String, dynamic> tomap() {
    return {
      'username': username,
      'senderId': senderId,
      'senderemail': senderemail,
      'reccieverid': reccieverid,
      'message': message,
      'timestamp': timestamp
    };
  }
}
