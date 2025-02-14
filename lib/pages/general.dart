import 'package:flutter/material.dart';

class General extends StatelessWidget {
  const General({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 55),
      decoration: BoxDecoration(color: Color.fromARGB(135, 50, 211, 200)),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assests/profile.jpg',
                  width: 90,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromARGB(222, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Text(
                    "A general doctor, also known as a general practitioner (GP) or family physician, is a medical professional who provides comprehensive healthcare to patients of all ages. They are often the first point of contact for people seeking medical care and can treat a wide range of conditions.",
                    style: TextStyle(
                        color: Color.fromARGB(211, 0, 0, 0), fontSize: 13),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
