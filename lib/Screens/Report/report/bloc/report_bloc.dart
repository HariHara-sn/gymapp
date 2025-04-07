import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/report_member_repo.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final MemberRepository memberRepository;

  ReportBloc(this.memberRepository) : super(ReportLoading()) {
    on<FetchReport>(_onFetchReport);
  }

  Future<void> _onFetchReport(FetchReport event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final members = await memberRepository.fetchMembers(
        month: event.month,
        gymId: event.gymId,
      );
      emit(ReportLoaded(members));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}
