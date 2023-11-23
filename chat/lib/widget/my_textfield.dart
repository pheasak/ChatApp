import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Mytext extends StatefulWidget {
  final String hintext;
  final TextEditingController controller;
  late bool obscurtext;
  Mytext(
      {required this.controller,
      required this.hintext,
      required this.obscurtext,
      super.key});

  @override
  State<Mytext> createState() => _MytextState();
}

class _MytextState extends State<Mytext> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.withOpacity(0.5)),
        child: TextField(
          controller: widget.controller,
          obscureText:
              widget.hintext == 'Passwords' ? widget.obscurtext : false,
          decoration: InputDecoration(
              labelText: widget.hintext,
              suffixIcon: widget.hintext == 'Passwords'
                  ? Icon(Icons.visibility_off)
                  : null,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
      ),
    );
  }
}
