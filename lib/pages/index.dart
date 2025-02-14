import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Index(),
  ));
}

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0; // Track the selected index

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    // The content you already have for your main page
    SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text("Welcome Back",
                style: TextStyle(
                    fontFamily: 'Poppin',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 63, 151, 158))),
            SizedBox(height: 5),
            Text("What are you looking for?",
                style: TextStyle(
                    fontFamily: 'Poppin',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff565656))),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 42, 42, 42).withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  )
                ],
                color: Color.fromARGB(255, 232, 232, 232),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Search the Doctor",
                          hintStyle:
                              TextStyle(fontFamily: 'Poppin', fontSize: 17),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      width: 130,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xff477cfe),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset('assests/stet.png', width: 70),
                          SizedBox(height: 1),
                          Text("General",
                              style: TextStyle(
                                  fontFamily: 'Poppin',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff565656))),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: 130,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xff56b3d4),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xff56b3d4).withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset('assests/eye.png', width: 100),
                          SizedBox(height: 1),
                          Text("Optalmology",
                              style: TextStyle(
                                  fontFamily: 'Poppin',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff565656))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: 130,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xfffdb45f),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xfffdb45f).withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assests/brain.png',
                            width: 100,
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text("Neurology",
                              style: TextStyle(
                                  fontFamily: 'Poppin',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff565656))),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      width: 130,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xfffdb45f),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assests/teeth.png',
                            width: 90,
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text("Dental",
                              style: TextStyle(
                                  fontFamily: 'Poppin',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff565656))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: 130,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xffef7069),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff56b3d4).withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assests/heart.png',
                            width: 105,
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            "Cardiology",
                            style: TextStyle(
                                fontFamily: 'Poppin',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xff565656)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: 130,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xff477cfe),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xfffdb45f).withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assests/laboo.png',
                            width: 55,
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text("Laboratory",
                              style: TextStyle(
                                  fontFamily: 'Poppin',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff565656))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    Center(child: Text("Page 2 Content")), // Second page example
    Center(child: Text("Page 3 Content")), // Third page example
  ];

  // Method to handle tab selection
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      appBar: AppBar(
        backgroundColor: Color(0xffE5E5E5),
        leading: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0), child: Icon(Icons.menu)),
        title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text("Hello User !!")),
        actions: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Icon(Icons.notifications))
        ],
      ),
      body: _pages[_selectedIndex], // Display the content of the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Keep track of selected tab
        onTap: _onTabSelected, // Call the method when a tab is selected
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
