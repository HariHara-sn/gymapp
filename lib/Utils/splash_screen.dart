import 'package:flutter/material.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:gymapp/Utils/bottom_navigationbar.dart';
import 'package:gymapp/login_page_1.dart';
import 'package:gymapp/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../provider/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.5;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        final authCubit = context.read<AuthCubit>().state; // Access Cubit

        logger.d("Auth Token from Cubit: $authCubit");
        final initialRoute =
            authCubit == null
                ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                )
                : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyNavigationBar()),
                  (route) => false,
                );
        // Navigator.of(context).pushNamedAndRemoveUntil(initialRoute, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _opacity,
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(seconds: 1),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/logo/logo.jpg'),
                  radius: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
