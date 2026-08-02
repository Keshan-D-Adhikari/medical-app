import 'package:flutter/material.dart';
import 'package:medical_app/pages/login_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The column lays out at roughly 580px, which overflows on short phones
    // (and sits uncomfortably close to the 600px widget-test surface), so the
    // content scrolls rather than clipping.
    return Scaffold(
      backgroundColor: Color(0xffaaeaf4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Container(
            decoration: BoxDecoration(color: Color(0xffaaeaf4)),
            child: Column(
              children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Image.asset('assests/doc.png'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Find Your Specialist",
                style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Poppin',
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Now it is easy to make an \n appointment with your doctor ",
                style: TextStyle(fontSize: 16, fontFamily: 'Poppin'),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 70,
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
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 200,
                  decoration: BoxDecoration(
                      color: Color(0xff000000),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          fontFamily: 'PoppinBold',
                          fontSize: 20,
                          color: Color(0xffffffff)),
                    ),
                  ),
                ),
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
