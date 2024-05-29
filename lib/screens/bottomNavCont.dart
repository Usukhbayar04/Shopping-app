import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../const/AppColors.dart';
import 'bottomNavScreens/cart.dart';
import 'bottomNavScreens/favorite.dart';
import 'bottomNavScreens/home.dart';
import 'bottomNavScreens/profile.dart';

class BottomNavController extends StatefulWidget {
  final User user;
  const BottomNavController({super.key, required this.user});

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      Home(),
      Cart(),
      Favorite(),
      Profile(),
    ];
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.white_Color,
        unselectedItemColor: AppColors.whiteOp_Color,
        selectedLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.brand_Color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
            backgroundColor: AppColors.brand_Color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
            backgroundColor: AppColors.brand_Color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: AppColors.brand_Color,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
