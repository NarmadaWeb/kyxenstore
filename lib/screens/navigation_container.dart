import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'explore_screen.dart';
import 'marketplace_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({super.key});

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ExploreScreen(),
    const MarketplaceScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Badge(
                    label: Text(cart.itemCount.toString()),
                    isLabelVisible: cart.itemCount > 0,
                    child: const Icon(Icons.shopping_bag),
                  );
                },
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-edit');
              },
              backgroundColor: const Color(0xFF137fec),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, size: 28),
            )
          : null,
    );
  }
}
