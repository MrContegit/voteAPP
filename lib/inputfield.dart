import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInputFieldFb1 extends StatelessWidget {
  final TextEditingController inputController;
  final TextInputType type;
  final String hintText;
  final Color primaryColor;
  final String labelText;
  final bool? enable;

  const CustomInputFieldFb1(
      {Key? key,
      required this.inputController,
      required this.hintText,
      required this.labelText,
      required this.type,
      this.primaryColor = Colors.indigo, this.enable=true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20,0,20,0),
      height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        enabled: enable,
        controller: inputController,
        onChanged: (value) {
          //Do something wi
        },
        keyboardType: type,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Color.fromARGB(255, 46, 43, 43).withOpacity(.75)),
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
        ),
      ),
    );
  }
}