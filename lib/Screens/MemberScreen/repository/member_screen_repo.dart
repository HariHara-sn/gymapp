import 'package:gymapp/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/memberscreen_model.dart';

class WorkoutRepositoryImpl {
  final SupabaseClient supabaseClient;

  WorkoutRepositoryImpl({required this.supabaseClient});

  Future<List<ExerciseModel>> getExercises() async {
    try {
      final response = await supabaseClient
          .from('gym_exercises')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList();
    } catch (e) {
      logger.e("Error fetching exercises: $e");
      rethrow;
    }
  }

  Future<List<NoticeModel>> getNotices() async {
    try {
      final response = await supabaseClient
          .from('gym_notices')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((e) => NoticeModel.fromJson(e))
          .toList();
    } catch (e) {
      logger.e("Error fetching notices: $e");
      rethrow;
    }
  }

  Future<UpiModel> getUpiDetails() async {
    try {
      final response = await supabaseClient
          .from('payment_qr')
          .select()
          .order('created_at', ascending: false)
          .single();
      
      return UpiModel.fromJson(response);
    } catch (e) {
      logger.e("Error fetching UPI details: $e");
      rethrow;
    }
  }
}