import 'package:supabase_flutter/supabase_flutter.dart';

import '../Screens/Dashboard/models/dashboard_model.dart';


class DashboardRepository {
  final SupabaseClient supabase;

  DashboardRepository({required this.supabase});

  Future<void> saveDataToSupabase(
      List<Exercise> exercises, List<Notice> notices, String upiId, String amount) async {
    try {
      for (var exercise in exercises) {
        await supabase.from('gym_dashboard').insert({
          ...exercise.toMap(),
          'notice_title': notices.isNotEmpty ? notices[0].title : "",
          'notice_desc': notices.isNotEmpty ? notices[0].description : "",
          'upi_id': upiId,
          'amount': double.tryParse(amount) ?? 0,
        });
      }
    } catch (e) {
      throw Exception("Error Saving Data: $e");
    }
  }
}
