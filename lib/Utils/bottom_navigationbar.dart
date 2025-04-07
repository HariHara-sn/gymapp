import 'package:flutter/material.dart';
import 'package:gymapp/Screens/MemberDashboard/member_dashboard_screen.dart';
import '../Screens/Home/members_list_page.dart';
import 'package:gymapp/Theme/appcolor.dart';

import '../screens/collection_screen.dart';
import '../screens/Dashboard/dashboard_screen.dart';

import '../screens/Report/report_screen.dart';


class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Membersinfo(), 
    DashboardScreen(),
    CollectionScreen(),
    MemberDashboardScreen(),
    ReportScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display selected page
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.lightGrey,
          selectedItemColor: AppColors.lightgreen,
          selectedIconTheme: IconThemeData(
            size: 30,
            color: AppColors.maingreen,
          ),
          unselectedIconTheme: IconThemeData(size: 25, color: Colors.white),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped, // Handle navigation
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/membersIcon.png")),
              label: "Members",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/dashboardIcon.png")),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/collectionIcon.png")),
              label: "Collection",
            ),
              BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/gymIcon.png")),
              label: "Member Dashboard",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/todayReportIcon.png")),
              label: "Report",
            ),
          ],
        ),
      ),
    );
  }
}
