import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymapp/Utils/splash_screen.dart';
import 'package:gymapp/provider/auth_cubit.dart';
import 'package:gymapp/secrets/secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'Screens/Dashboard/cubit/dashboard_cubit.dart';
import 'Screens/Dashboard/repository/dashboard_repo.dart';
import 'Screens/MemberScreen/cubit/workout_cubit.dart';
import 'Screens/MemberScreen/repository/member_screen_repo.dart';
import 'Theme/app_theme.dart';
import 'Utils/custom_snack_bar.dart';
import 'logic/bloc/auth_bloc.dart';
import 'repositories/auth_repository.dart';

final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


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
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(), 
        ),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider<WorkoutCubit>(
          create:
              (context) => WorkoutCubit(
                repository: WorkoutRepositoryImpl(
                  supabaseClient: Supabase.instance.client,
                ),
              ),
        ),
        BlocProvider<DashboardCubit>(
          create:
              (context) => DashboardCubit(
                repository: DashboardRepository(
                  supabaseClient: Supabase.instance.client,
                ),
              ),
        ),
        
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
