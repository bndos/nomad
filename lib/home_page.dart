import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

import 'package:nomad/screens/map_screen.dart';
import 'package:nomad/screens/explore_screen.dart';
import 'package:nomad/screens/chats_screen.dart';
import 'package:nomad/screens/profile_screen.dart';

import 'package:nomad/screens/camera_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MapScreen(),
    const ExploreScreen(),
    Container(),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedIndex == 2 ? Colors.black : Colors.white,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              for (var screen in _screens) screen,
            ],
          ),
          if (_selectedIndex == 2) // Only show the CameraScreen when selected
            const CameraScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        color: _selectedIndex == 2 ? Colors.black : Colors.white,
        child: SafeArea(
          child: GNav(
            gap: 2,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            tabBackgroundColor: _selectedIndex == 2
                ? Colors.grey.withOpacity(0.15)
                : Colors.grey.shade100,
            backgroundColor: _selectedIndex == 2 ? Colors.black : Colors.white,
            color: _selectedIndex == 2 ? Colors.grey.shade200 : Colors.black,
            activeColor:
                _selectedIndex == 2 ? Colors.grey.shade200 : Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            tabMargin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Iconsax.map_1,
                text: 'Map',
              ),
              GButton(
                icon: Icons.search,
                text: 'Explore',
              ),
              GButton(
                icon: Iconsax.camera,
                text: 'Camera',
              ),
              GButton(
                icon: Iconsax.message,
                text: 'Chats',
              ),
              GButton(
                icon: Icons.person_outline,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
