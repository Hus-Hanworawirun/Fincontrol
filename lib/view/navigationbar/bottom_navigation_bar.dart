import 'package:fincontrol/view/activity/activity_page.dart';
import 'package:fincontrol/view/home/home_page.dart';
import 'package:fincontrol/view/navigationbar/add_transaction_sheet.dart';
import 'package:fincontrol/view/profile/profile_page.dart';
import 'package:fincontrol/view/wealth/wealth_page.dart';
import 'package:flutter/material.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(onSeeAllActivity: () => _onItemTapped(1)),
      const ActivityPage(),
      const WealthPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      floatingActionButton: SizedBox(
        height: 64,
        width: 64,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => AddTransactionSheet(),
            );
          },
          backgroundColor: const Color(0xFF4F3FF0),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Activity',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Wealth'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Profile'),
        ],
      ),
    );
  }
}
