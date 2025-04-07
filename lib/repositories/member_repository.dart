import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import '../Models/member_model.dart';

class MemberRepository {
  final SupabaseClient supabase;

  MemberRepository(this.supabase);

  Future<void> addMember(Member member, File? imageFile) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }

      await supabase.from('memberinfo').insert(member.toMap());
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileName = 'membersphoto_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final filePath = 'membersphotos/$fileName';

      await supabase.storage.from('membersphotos').upload(filePath, imageFile);
      return supabase.storage.from('membersphotos').getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  Future<List<Member>> getMembersByGym(String gymId) async {
    try {
      final response = await supabase
          .from('memberinfo')
          .select()
          .eq('gymId', gymId);

      return response.map<Member>((map) => Member.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch members: $e');
    }
  }
}