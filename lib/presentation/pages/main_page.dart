import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          hoverElevation: 10,
          backgroundColor: const Color(0xFF1A3C40),
          foregroundColor: const Color(0xFFEDE6DB),
          elevation: 4,
          child: const Icon(Icons.add),
          onPressed: () {
            context.go('/home/add-story');
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0x40417D7A),
        selectedItemColor: const Color(0xFF1A3C40),
        unselectedItemColor: Colors.grey[800],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 28.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile Page',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/profile')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed('home');
        break;
      case 1:
        context.goNamed('profile');
        break;
    }
  }
}
