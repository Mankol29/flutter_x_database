import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/HomePage/homepage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
<<<<<<< HEAD

import 'adminFolder/adminFeatures/table_list_page_gnav.dart';
=======
import 'admin folder/admin features/table_list_page_gnav.dart';
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482


class HomePageGnav extends StatefulWidget {
  final String userRole;

  const HomePageGnav({required this.userRole, Key? key}) : super(key: key);

  @override
  State<HomePageGnav> createState() => _HomePageGnavState();
}

class _HomePageGnavState extends State<HomePageGnav> {
  late int _selectedIndex = 0;
  late String userRole;

  @override
  void initState() {
    super.initState();
    userRole = widget.userRole;
  }

  void _navigateGnav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(userRole: userRole),
      TableListPageGnav(),
      Center(child: Text("Here will be search page")),
      Center(child: Text("Here will be settings page")),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(
        gap: 15,
        backgroundColor: Colors.purple,
        color: Colors.black,
        activeColor: Colors.black,
        tabBackgroundColor: Colors.purpleAccent,
        curve: Curves.easeOut,
        padding: EdgeInsets.all(20),
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
          print(index);
        },
        tabs: [
          GButton(
            icon: Icons.home,
            text: "Home",
          ),
          GButton(
            icon: Icons.table_chart,
            text: "Tables",
          ),
          GButton(
            icon: Icons.search_outlined,
            text: "Search",
          ),
          GButton(
            icon: Icons.settings,
            text: "Settings",
          ),
        ],
      ),
    );
  }
}
