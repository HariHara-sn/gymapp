import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> checkAndDeleteOldRecords() async {
  final supabase = Supabase.instance.client;
  final today = DateTime.now();
  final formattedToday = DateFormat('yyyy-MM-dd').format(today);

  // Fetch records from gym_exercises
  final exercises = await supabase.from('gym_exercises').select();

  final hasOldExercises = exercises.any((record) {
    final createdAt = DateTime.parse(record['created_at']);
    final createdAtFormatted = DateFormat('yyyy-MM-dd').format(createdAt);
    return createdAtFormatted != formattedToday;
  });

  if (hasOldExercises) {
    await supabase.from('gym_exercises').delete().neq('created_at', formattedToday);
  }

  // Fetch records from gym_notices
  final notices = await supabase.from('gym_notices').select();

  final hasOldNotices = notices.any((record) {
    final createdAt = DateTime.parse(record['created_at']);
    final createdAtFormatted = DateFormat('yyyy-MM-dd').format(createdAt);
    return createdAtFormatted != formattedToday;
  });

  if (hasOldNotices) {
    await supabase.from('gym_notices').delete().neq('created_at', formattedToday);
  }
}
