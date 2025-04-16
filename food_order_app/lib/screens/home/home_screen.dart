import 'package:flutter/material.dart';
import 'package:food_order_app/screens/cart/cart_screen.dart';
import 'package:food_order_app/screens/favourite/favourite_screen.dart';
import 'package:food_order_app/screens/home/home_form.dart'; // Add this import
import 'package:food_order_app/screens/notification/notification_screen.dart';
import 'package:food_order_app/screens/order_history/order_history_screen.dart';
import 'package:food_order_app/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeForm(),
    const OrderHistoryScreen(),
    const CartScreen(),
    const FavouriteScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png')),
            activeIcon: ImageIcon(AssetImage('assets/icons/home1.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/order_history.png')),
            activeIcon: ImageIcon(AssetImage('assets/icons/order_history1.png')),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/cart.png')),
            activeIcon: ImageIcon(AssetImage('assets/icons/cart1.png')),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/notification.png')),
            activeIcon: ImageIcon(AssetImage('assets/icons/notification1.png')),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
