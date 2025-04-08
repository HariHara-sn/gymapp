part of 'workout_cubit.dart';


abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<ExerciseModel> exercises;
  final List<NoticeModel> notices;
  final UpiModel? upiDetails;
  final String? qrReference;

  const WorkoutLoaded({
    required this.exercises,
    required this.notices,
    this.upiDetails,
    this.qrReference,
  });

  @override
  List<Object> get props => [exercises, notices, upiDetails ?? '', qrReference ?? ''];
}

class WorkoutError extends WorkoutState {
  final String message;

  const WorkoutError(this.message);

  @override
  List<Object> get props => [message];
}