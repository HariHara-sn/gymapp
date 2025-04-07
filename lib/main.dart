import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymapp/Utils/splash_screen.dart';
import 'package:gymapp/provider/auth_cubit.dart';
import 'package:gymapp/secrets/secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'Theme/app_theme.dart';
import 'Utils/custom_snack_bar.dart';
import 'logic/bloc/auth_bloc.dart';
import 'repositories/auth_repository.dart';

var logger = Logger();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true;  // Visual Layout
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  logger.i("Initial Token: $token");

  await Supabase.initialize(
    url: Secrets.supabaseUrl,
    anonKey: Secrets.annonkey,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(AuthRepository())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthCubit>().state; // load the token

    return MaterialApp(
      scaffoldMessengerKey: CustomSnackBar.scaffoldMessengerKey,
      theme: AppThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
