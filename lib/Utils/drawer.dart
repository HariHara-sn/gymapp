import 'package:flutter/material.dart';
import 'package:gymapp/Screens/Dashboard/dashboard_screen.dart';
import 'package:gymapp/Screens/Report/report_screen.dart';
import 'package:gymapp/Screens/collection_screen.dart';
import 'package:gymapp/Theme/appcolor.dart';

import '../provider/auth_cubit.dart';
import 'package:gymapp/login_page_1.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/auth_repository.dart';

class GymDrawer extends StatelessWidget {
  const GymDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return Drawer(
      child: Column(
        children: [
          // Header Section
          UserAccountsDrawerHeader(
            accountEmail: Text(''),
            accountName: Text("Gym 360"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/logo/logo.jpg",
              ), // Add profile image
            ),
            decoration: BoxDecoration(
              color: AppColors.greenAccent.withOpacity(
                0.5,
              ), // Customize the header color
            ),
          ),

          // Drawer Items
          ListTile(
            leading: Icon(Icons.dashboard, color: AppColors.greenAccent),
            title: Text("Dashboard"),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
              // Navigate to Dashboard Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: AppColors.greenAccent),
            title: Text("Members"),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Members Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics, color: AppColors.greenAccent),
            title: Text("Reports"),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportScreen()),
              );
              // Navigate to Reports Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.payment, color: AppColors.greenAccent),
            title: Text("Payments"),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CollectionScreen()),
              );
              // Navigate to Payments Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.greenAccent),
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Settings Screen
            },
          ),

          // Spacer(), // Pushes the Logout button to the bottom
          // Logout Button
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Call logout functions
              authRepository.signOut(); // Supabase sign-out
              context.read<AuthCubit>().clearToken(); // Clear token

              // Navigate to Login Screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
