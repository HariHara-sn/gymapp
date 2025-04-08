// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/report_member_model.dart';

// class ReportRepository {
//   final SupabaseClient supabase;

//   ReportRepository({required this.supabase});

//   Future<List<ReportMemberModel>> fetchPayments({
//     required String gymId,
//     String? month,
//   }) async {
//     var query = supabase
//         .from('memberinfo')
//         .select('member_id, name, payment_method, payment_status, gymId')
//         .eq('gymId', gymId);

//     if (month != null) {
//       String searchPattern = "-$month-${DateTime.now().year}";
//       int selectedMonth = int.parse(month);
//       int currentMonth = DateTime.now().month;

//       if (selectedMonth >= currentMonth) {
//         query = query.or(
//           "payment_status.ilike.%$searchPattern%, payment_status.eq.Pending",
//         );
//       } else {
//         query = query.ilike('payment_status', "%$searchPattern%");
//       }
//     } else {
//       query = query.or(
//         "payment_status.ilike.Paid%, payment_status.eq.Pending",
//       );
//     }

//     final response = await query;
//     return (response as List)
//         .map((e) => ReportMemberModel.fromJson(e))
//         .toList();
//   }
// }
