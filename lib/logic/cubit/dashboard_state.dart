

import '../../Screens/Dashboard/models/dashboard_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Exercise> exercises;
  final List<Notice> notices;
  final String upiId;
  final String amount;
  final String qrReference;

  DashboardLoaded({
    required this.exercises,
    required this.notices,
    required this.upiId,
    required this.amount,
    required this.qrReference,
  });
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
