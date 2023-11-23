import 'package:chat/controller/authemailpass.dart';
import 'package:chat/view/register.dart';
import 'package:chat/widget/button.dart';
import 'package:chat/widget/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Loginchat extends StatelessWidget {
  const Loginchat({super.key});

  @override
  Widget build(BuildContext context) {
    final _emailcontrl = TextEditingController();
    final _passwordcontrl = TextEditingController();

    void signin() async {
      final auth = Provider.of<AuthLog>(context, listen: false);
      try {
        await auth.signiwithEmailPass(_emailcontrl.text, _passwordcontrl.text);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Icon(
                Icons.login_outlined,
                size: 100,
              ),
              Mytext(
                  controller: _emailcontrl, hintext: 'Email', obscurtext: true),
              Mytext(
                  controller: _passwordcontrl,
                  hintext: 'Passwords',
                  obscurtext: true),
              Mybutton(
                  onprogess: () {
                    signin();
                  },
                  text: 'Sign In'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Haven\'t an account?'),
                  TextButton(
                      onPressed: () {
                        Get.to(Resgister());
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
