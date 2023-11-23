import 'package:chat/controller/authemailpass.dart';
import 'package:chat/view/home_page.dart';
import 'package:chat/widget/button.dart';
import 'package:chat/widget/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Resgister extends StatelessWidget {
  Resgister({super.key});
  final _emailcontrl = TextEditingController();
  final _passwordcontrl = TextEditingController();
  final _confirmcontrl = TextEditingController();
  final _usernamecontrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void signup() async {
      if (_passwordcontrl.text != _confirmcontrl.text) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Passwords not match')));
      }

      final auth = Provider.of<AuthLog>(context, listen: false);
      try {
        await auth.signupWithEmailpass(
            _emailcontrl.text, _passwordcontrl.text, _usernamecontrl.text);
        Get.snackbar(
            backgroundGradient:
                LinearGradient(colors: [Colors.red, Colors.green, Colors.blue]),
            'Welcome to our chat',
            'Your account create successfull');
        Get.off(Homepage());
      } on FirebaseAuthException catch (e) {
        throw Exception(e.code);
      }
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.login_outlined,
            size: 40,
          ),
          Mytext(controller: _emailcontrl, hintext: 'Email', obscurtext: false),
          Mytext(
              controller: _usernamecontrl,
              hintext: 'User-name',
              obscurtext: false),
          Mytext(
              controller: _passwordcontrl,
              hintext: 'Passwords',
              obscurtext: false),
          Mytext(
              controller: _confirmcontrl,
              hintext: 'Confirm',
              obscurtext: false),
          Mybutton(
              onprogess: () {
                signup();
              },
              text: 'Sign In'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('already have account?'),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Login now',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          )
        ],
      )),
    );
  }
}
