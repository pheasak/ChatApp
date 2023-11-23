import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final String text;
  final void Function() onprogess;
  const Mybutton({required this.onprogess, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(15)),
      child: CupertinoButton(
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onprogess),
    );
  }
}
