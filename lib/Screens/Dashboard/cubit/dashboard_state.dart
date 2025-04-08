part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final PaymentModel payment;

  const DashboardLoaded({required this.payment});

  @override
  List<Object> get props => [payment];
}

class DashboardSaving extends DashboardState {}

class DashboardSaved extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}