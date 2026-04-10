import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/menu_screen.dart';
import 'screens/order_screen.dart';

void main() {
  runApp(const ProviderScope(child: CloverPosApp()));
}

class CloverPosApp extends StatelessWidget {
  const CloverPosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clover POS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CloverPosHome(),
    );
  }
}

class CloverPosHome extends StatefulWidget {
  const CloverPosHome({Key? key}) : super(key: key);

  @override
  State<CloverPosHome> createState() => _CloverPosHomeState();
}

class _CloverPosHomeState extends State<CloverPosHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MenuScreen(),
    OrderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clover POS System'),
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
