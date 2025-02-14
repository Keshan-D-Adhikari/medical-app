import 'package:flutter/material.dart';
import 'package:medical_app/pages/index.dart';
import 'package:medical_app/pages/login_page.dart';
import 'package:medical_app/pages/widgets/signup_input.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 60, 10, 0),
          width: double.infinity,
          height: 780,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assests/signup.jpg'), fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Welcome Doct App",
                  style: TextStyle(
                      fontFamily: "Poppin",
                      fontSize: 28,
                      color: Color.fromARGB(255, 79, 79, 79),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Sign up to book appoinments and\n manage your health easily",
                style: TextStyle(
                    fontFamily: 'Poppin',
                    fontSize: 15,
                    color: Color.fromARGB(255, 79, 79, 79),
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 28,
              ),
              SignupInput(hintText: "First Name", inputIcon: Icons.person),
              SizedBox(
                height: 23,
              ),
              SignupInput(hintText: "Last Name", inputIcon: Icons.person),
              SizedBox(
                height: 23,
              ),
              SignupInput(hintText: "Email", inputIcon: Icons.email),
              SizedBox(
                height: 23,
              ),
              SignupInput(hintText: "Phone Number", inputIcon: Icons.phone),
              SizedBox(
                height: 23,
              ),
              SignupInput(
                  hintText: "Date of Birth", inputIcon: Icons.calendar_today),
              SizedBox(
                height: 20,
              ),
              Text(
                "Creating an account means you\n agree with our Terms and Services",
                style: TextStyle(
                  fontFamily: 'Poppin',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 79, 79, 79),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Index(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: 250,
                  decoration: BoxDecoration(
                    color: Color(0xff7de2ea),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Color.fromARGB(255, 0, 0, 0), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 42, 42, 42)
                            .withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 4, // Blur radius
                        offset: const Offset(0, 3), // Offset from the container
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    "Create an account",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppin',
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 79, 79, 79),
                    ),
                  )),
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
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text(
                  "Already have an account ? Sign in",
                  style: TextStyle(
                      fontFamily: 'Poppin',
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 79, 79, 79)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
