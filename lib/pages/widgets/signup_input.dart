import 'package:flutter/material.dart';

class SignupInput extends StatelessWidget {
  final String hintText;
  final IconData inputIcon;
  const SignupInput(
      {super.key, required this.hintText, required this.inputIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: 280,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 192, 244, 248),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color.fromARGB(255, 179, 179, 179))),
      child: Row(
        children: [
          Icon(inputIcon),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(fontFamily: 'Poppin')),
            ),
          )
        ],
      ),
    );
  }
}
