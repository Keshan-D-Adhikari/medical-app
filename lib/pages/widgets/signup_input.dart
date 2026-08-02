import 'package:flutter/material.dart';

class SignupInput extends StatelessWidget {
  final String hintText;
  final IconData inputIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final bool enabled;

  const SignupInput({
    super.key,
    required this.hintText,
    required this.inputIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
  });

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
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              validator: validator,
              textInputAction: textInputAction,
              enabled: enabled,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  errorStyle: TextStyle(
                    fontFamily: 'Poppin',
                    color: Color(0xffb00020),
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: TextStyle(fontFamily: 'Poppin')),
            ),
          )
        ],
      ),
    );
  }
}
