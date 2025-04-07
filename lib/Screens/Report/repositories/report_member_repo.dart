import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_member_model.dart';

class MemberRepository {
  final SupabaseClient supabase;

  MemberRepository(this.supabase);

  Future<List<Member>> fetchMembers({String? month, required String gymId}) async {
    try {
      var query = supabase
          .from('memberinfo')
          .select('name, payment_method, paid_amount, paid_date')
          .eq('gymId', gymId);

      if (month != null) {
        query = query.ilike('paid_date', '%-${int.parse(month)}-%');
      }

      final response = await query;
      return response.map<Member>((data) => Member.fromJson(data)).toList();
    } catch (e) {
      throw Exception("Error fetching members: $e");
    }
  }
}
