import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Addfriend extends StatelessWidget {
  final String currentuserid;
  final String uname;
  Addfriend({required this.currentuserid, required this.uname, super.key});
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  void add(String email, String username, String uid) async {
    await firestore
        .collection('users')
        .doc(currentuserid)
        .collection('friends')
        .doc()
        .set({'uid': uid, 'email': email, 'username': username});
    await firestore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc()
        .set({
      'uid': currentuserid,
      'email': auth.currentUser!.email,
      'username': uname
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend'),
      ),
      body: _buildListUser(),
    );
  }

  Widget _buildListUser() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error......');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading.....');
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildItem(doc, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildItem(DocumentSnapshot document, BuildContext context) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text('${data['username']}'),
        trailing: IconButton(
            onPressed: () {
              add(data['email'], data['username'], data['uid']);
            },
            icon: Icon(Icons.add)),
      );
    } else {
      return Container();
    }
  }
}
