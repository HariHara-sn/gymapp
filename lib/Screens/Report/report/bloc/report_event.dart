import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchReport extends ReportEvent {
  final String? month;
  final String gymId;

  FetchReport({this.month, required this.gymId});

  @override
  List<Object?> get props => [month, gymId];
}
