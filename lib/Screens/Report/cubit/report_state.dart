part of 'report_cubit.dart';

abstract class ReportState {
  const ReportState();
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final Report report;
  const ReportLoaded(this.report);
}

class ReportError extends ReportState {
  final String message;
  const ReportError(this.message);
}