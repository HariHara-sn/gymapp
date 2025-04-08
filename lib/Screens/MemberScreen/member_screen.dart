import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cubit/workout_cubit.dart';
import 'repository/member_screen_repo.dart';
import 'widgets/notice_card.dart';
import 'widgets/qr_payment_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutCubit(
        repository: WorkoutRepositoryImpl(
          supabaseClient: Supabase.instance.client,
        ),
      )..fetchWorkoutData(),
      child: Scaffold(
        body: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutLoading) {
              return  Center(child: CircularProgressIndicator(color: AppColors.greenAccent));
            }

            if (state is WorkoutError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is WorkoutLoaded) {
              return _buildContent(context, state);
            }

            return const Center(child: Text('Initial state'));
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WorkoutLoaded state) {
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gym Title
          Text(
            '360 Gym',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.greenAccent,
            ),
          ),

          const SizedBox(height: 5),

          // Date
          Text(
            formattedDate,
            style: GoogleFonts.poppins(fontSize: 14, color: AppColors.white),
          ),

          // Exercise of the Day
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              'Exercise of the Day',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
            ),
          ),

          state.exercises.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.exercises.map((exercise) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.exerciseTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenAccent,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          exercise.exerciseDesc,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "No event today",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ),

          Text(
            'Important Notices',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.greenAccent,
            ),
          ),

          const SizedBox(height: 10),

          state.notices.isNotEmpty
              ? Column(
                  children: state.notices.map((notice) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: NoticeCard(
                        title: notice.noticeTitle,
                        description: notice.noticeDesc,
                        date: formattedDate,
                      ),
                    );
                  }).toList(),
                )
              : NoticeCard(
                  title: "No event today",
                  description: "",
                  date: formattedDate,
                ),

          const SizedBox(height: 20),

          if (state.upiDetails != null && state.qrReference != null)
            QuickPaymentCard(
              upiId: state.upiDetails!.upiId,
              amount: state.upiDetails!.amount.toString(),
              qrReference: state.qrReference!,
            ),
        ],
      ),
    );
  }
}