import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/memberscreen_model.dart';
import '../repository/member_screen_repo.dart';
part 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepositoryImpl repository;

  WorkoutCubit({required this.repository}) : super(WorkoutInitial());

  Future<void> fetchWorkoutData() async {
    emit(WorkoutLoading());
    try {
      final exercises = await repository.getExercises();
      final notices = await repository.getNotices();
      final upiDetails = await repository.getUpiDetails();
      final qrReference = "upi://pay?pa=${upiDetails.upiId}&am=${upiDetails.amount}&cu=INR";

      emit(WorkoutLoaded(
        exercises: exercises,
        notices: notices,
        upiDetails: upiDetails,
        qrReference: qrReference,
      ));
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }
}