import 'package:flutter/material.dart';
import 'package:medical_app/pages/general.dart';

import 'package:medical_app/pages/signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecfbff),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 130),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                    'assests/logo.png',
                    width: 170,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "DoctApp",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Poppin',
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Color(0xffD9F5F3),
                    borderRadius: BorderRadius.circular(25),
                    border:
                        Border.all(color: Color.fromARGB(255, 181, 181, 181))),
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(Icons.email),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Email Adress",
                            hintStyle: TextStyle(fontFamily: 'Poppin'),
                            border: InputBorder.none),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Color(0xffD9F5F3),
                    borderRadius: BorderRadius.circular(25),
                    border:
                        Border.all(color: Color.fromARGB(255, 181, 181, 181))),
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(Icons.lock),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(fontFamily: 'Poppin'),
                            border: InputBorder.none),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Forgot password ?",
                style: TextStyle(
                    fontFamily: 'Poppin',
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => General(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 150,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.5), //color of shadow
                          spreadRadius: 2, // how much the shadow should spread
                          blurRadius: 2, // how blurry the shadow should be
                          offset:
                              const Offset(0, 3), // the offset of the shadow
                        ),
                      ],
                      color: Color(0xffaaeaf4),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                          color: Color.fromARGB(255, 181, 181, 181))),
                  child: Center(
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppin',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupPage(),
                    ),
                  );
                },
                child: Text(
                  "Need an Account ? Sign up",
                  style: TextStyle(
                      fontFamily: 'Poppin',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
