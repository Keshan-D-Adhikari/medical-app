import 'package:flutter/material.dart';

class General extends StatelessWidget {
  const General({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapped in a Scaffold because this is pushed as a full route; the bare
    // Container had no Material ancestor and a hardcoded 600px height that
    // overflowed on short screens.
    return Scaffold(
      backgroundColor: Color.fromARGB(135, 50, 211, 200),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(135, 50, 211, 200),
        elevation: 0,
        title: Text(
          "General Practitioner",
          style: TextStyle(fontFamily: 'Poppin', fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assests/profile.jpg',
                  width: 90,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromARGB(222, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  "A general doctor, also known as a general practitioner (GP) or family physician, is a medical professional who provides comprehensive healthcare to patients of all ages. They are often the first point of contact for people seeking medical care and can treat a wide range of conditions.",
                  style: TextStyle(
                      fontFamily: 'Poppin',
                      color: Color.fromARGB(211, 0, 0, 0),
                      fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
