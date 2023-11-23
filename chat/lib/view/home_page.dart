import 'package:chat/controller/authemailpass.dart';
import 'package:chat/view/addfriends.dart';
import 'package:chat/view/chatpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  String? uname;
  @override
  Widget build(BuildContext context) {
    void logout() async {
      final auth = Provider.of<AuthLog>(context, listen: false);
      await auth.signout();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: _buildListUser(),
      floatingActionButton: StreamBuilder(
        stream:
            firebase.collection('users').doc(auth.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          var db = snapshot.data;
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addfriend(
                        currentuserid: auth.currentUser!.uid,
                        uname: db!['username']),
                  ));
            },
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }

  Widget _buildListUser() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('friends')
          .snapshots(),
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
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                    username: data['username'],
                    receiverUserId: data['uid'],
                    receiverUseremail: data['email']),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
