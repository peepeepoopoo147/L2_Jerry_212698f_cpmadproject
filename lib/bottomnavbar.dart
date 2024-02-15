import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/musichome');
        break;
      case 1:
        Navigator.of(context).pushNamed('/searchpage');
        break;
      case 2:
        Navigator.of(context).pushNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => _onTap(context, index),
      backgroundColor: Colors.black.withOpacity(0.1),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music),
          label: 'Library',
        ),
      ],
    );
  }
}
