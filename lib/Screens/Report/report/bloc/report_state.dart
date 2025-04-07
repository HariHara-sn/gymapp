import 'package:equatable/equatable.dart';

import '../../models/report_member_model.dart';

abstract class ReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final List<Member> members;

  ReportLoaded(this.members);

  @override
  List<Object?> get props => [members];
}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);

  @override
  List<Object?> get props => [message];
}
