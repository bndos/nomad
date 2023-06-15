import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

import 'package:nomad/screens/map_screen.dart';
import 'package:nomad/screens/explore_screen.dart';
import 'package:nomad/screens/camera_screen.dart';
import 'package:nomad/screens/chats_screen.dart';
import 'package:nomad/screens/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MapScreen(),
    const ExploreScreen(),
    const CameraScreen(),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10),
        color: Colors.white,
        child: SafeArea(
          child: GNav(
            gap: 2,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            tabBackgroundColor: Colors.grey.shade100,
            backgroundColor: Colors.white,
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
