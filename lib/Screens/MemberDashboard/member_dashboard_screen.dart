import 'package:flutter/material.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:gymapp/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/data_cleaner.dart';

class MemberDashboardScreen extends StatefulWidget {
  const MemberDashboardScreen({super.key});

  @override
  State<MemberDashboardScreen> createState() => _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> exercises = [];
  List<Map<String, dynamic>> notices = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
     checkAndDeleteOldRecords();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
       if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final exRes = await supabase.from('gym_exercises').select();
      final noticeRes = await supabase.from('gym_notices').select();

      setState(() {
        exercises = List<Map<String, dynamic>>.from(exRes);
        notices = List<Map<String, dynamic>>.from(noticeRes);
        isLoading = false;
      });
    } catch (e) {
         if (!mounted) return;
      logger.e("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteItem(String table, String id) async {
  
    await supabase.from(table).delete().eq('id', id);
    _fetchAllData();
  }

  Future<void> _editItem({
    required String table,
    required String id,
    required String titleField,
    required String descField,
    required String currentTitle,
    required String currentDesc,
  }) async {
    TextEditingController titleCtrl = TextEditingController(text: currentTitle);
    TextEditingController descCtrl = TextEditingController(text: currentDesc);

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Edit Entry",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.greenAccent,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(color: AppColors.white),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await supabase
                      .from(table)
                      .update({
                        titleField: titleCtrl.text,
                        descField: descCtrl.text,
                      })
                      .eq('id', id);
                  Navigator.pop(context);
                  _fetchAllData();
                },
                child: Text(
                  "Save",
                  style: GoogleFonts.poppins(
                    color: AppColors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildCard({
    required Map<String, dynamic> data,
    required String titleKey,
    required String descKey,
    required String tableName,
  }) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          data[titleKey] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          data[descKey] ?? '',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed:
                  () => _editItem(
                    table: tableName,
                    id: data['id'],
                    titleField: titleKey,
                    descField: descKey,
                    currentTitle: data[titleKey],
                    currentDesc: data[descKey],
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _deleteItem(tableName, data['id']),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Member Dashboard"),
        backgroundColor: Colors.greenAccent,
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: AppColors.greenAccent),
              )
              : RefreshIndicator(
                onRefresh: _fetchAllData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🏋️ Exercises",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...exercises.map(
                        (e) => _buildCard(
                          data: e,
                          titleKey: "exercise_title",
                          descKey: "exercise_desc",
                          tableName: "gym_exercises",
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "📢 Notices",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...notices.map(
                        (n) => _buildCard(
                          data: n,
                          titleKey: "notice_title",
                          descKey: "notice_desc",
                          tableName: "gym_notices",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
