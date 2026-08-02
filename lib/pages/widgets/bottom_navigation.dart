import 'package:flutter/material.dart';

/// The app's bottom navigation. `Index` used to inline its own copy of this
/// widget with a different tab list; both now come from here so they cannot
/// drift apart again.
class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  static const List<BottomNavigationBarItem> items = [
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
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: 'Profile',
    ),
  ];

  const CustomBottomNavigationBar({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTabSelected,
      // Four items would otherwise switch to the shifting style and hide labels.
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xff3f979e),
      unselectedItemColor: const Color(0xff9e9e9e),
      selectedLabelStyle: const TextStyle(fontFamily: 'Poppin'),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Poppin'),
      items: items,
    );
  }
}
