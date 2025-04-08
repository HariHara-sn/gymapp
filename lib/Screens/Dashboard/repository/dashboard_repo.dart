import 'package:gymapp/Screens/Dashboard/model/dashboard_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardRepository {
  final SupabaseClient supabaseClient;

  DashboardRepository({required this.supabaseClient});

  Future<PaymentModel> getPaymentDetails() async {
    final response =
        await supabaseClient
            .from('payment_qr')
            .select()
            .order('created_at', ascending: false)
            .limit(1)
            .single();
    return PaymentModel.fromJson(response);
  }

  Future<void> saveExercises(List<ExerciseModel> exercises) async {
    await supabaseClient
        .from('gym_exercises')
        .upsert(exercises.map((e) => e.toJson()).toList());
  }

  Future<void> saveNotices(List<NoticeModel> notices) async {
    await supabaseClient
        .from('gym_notices')
        .upsert(notices.map((e) => e.toJson()).toList());
  }

  Future<void> updatePaymentDetails(PaymentModel payment) async {
    await supabaseClient.from('payment_qr').upsert(payment.toJson());
  }
}
