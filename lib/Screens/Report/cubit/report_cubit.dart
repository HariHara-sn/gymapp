import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymapp/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/report_member_model.dart';


part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final SupabaseClient supabase;

  ReportCubit({required this.supabase}) : super(ReportInitial());

  Future<void> fetchPayments({String? month, bool yearly = false}) async {
    emit(ReportLoading());
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      var query = supabase
          .from('memberinfo')
          .select('member_id, name, payment_method, payment_status, gymId')
          .eq('gymId', user.id);

      if (month != null) {
        String searchPattern = "-$month-${DateTime.now().year}";
        int selectedMonth = int.parse(month);
        int currentMonth = DateTime.now().month;

        if (selectedMonth >= currentMonth) {
          query = query.or(
            "payment_status.ilike.%$searchPattern%, payment_status.eq.Pending",
          );
        } else {
          query = query.ilike('payment_status', "%$searchPattern%");
        }
      } else {
        query = query.or(
          "payment_status.ilike.Paid%, payment_status.eq.Pending",
        );
      }

      final response = await query;
      final members = (response as List).map((e) => ReportMemberModel.fromJson(e)).toList();
      
      emit(ReportLoaded(Report(
        members: members,
        month: month,
        isYearly: yearly,
      )));
    } catch (e) {
      logger.e(e.toString());
      emit(ReportError(e.toString()));
    }
  }
}