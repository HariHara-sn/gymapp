import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
import 'package:gymapp/main.dart';
import '../../Theme/appcolor.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MemberDetailsPage extends StatefulWidget {
  final Map<String, dynamic> member;
  final VoidCallback onDelete; // Callback for deletion

  const MemberDetailsPage({
    super.key,
    required this.member,
    required this.onDelete,
  });

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController chestController;
  late TextEditingController waistController;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    heightController = TextEditingController(
      text: widget.member['height'] ?? '',
    );
    weightController = TextEditingController(
      text: widget.member['weight'] ?? '',
    );
    waistController = TextEditingController(text: widget.member['waist'] ?? '');
    chestController = TextEditingController(text: widget.member['chest'] ?? '');
  }

  @override
  void dispose() {
    heightController.dispose();
    chestController.dispose();
    super.dispose();
  }

  Future<void> updateMemberData() async {
    final supabase = Supabase.instance.client;
    final memberId = widget.member['member_id'];

    try {
      await supabase
          .from('memberinfo')
          .update({
            'height': heightController.text,
            'chest': chestController.text,
            'weight': weightController.text,
            'waist': waistController.text,
          })
          .eq('member_id', memberId);

      logger.i("Updated");

      CustomSnackBar.showSnackBar(
        "Member updated successfully",
        SnackBarType.success,
      );

 
      final updatedMember =
          await supabase
              .from('memberinfo')
              .select()
              .eq('member_id', memberId)
              .single();

      setState(() {
        widget.member.addAll(updatedMember);
        heightController.text = updatedMember['height'] ?? '';
        weightController.text = updatedMember['weight'] ?? '';
        chestController.text = updatedMember['chest'] ?? '';
        waistController.text = updatedMember['waist'] ?? '';
      });
    } catch (error) {
      logger.e(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: ${error.toString()}')),
      );
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this member?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenAccent,
        title: AutoSizeText(
          "Member Information",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.backgroundColor,
          ),

          maxLines: 1,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 80),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.greenAccent, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        widget.member['member_img'] ??
                            "https://picsum.photos/200",
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red, size: 30),
                      onPressed: () => showDeleteConfirmationDialog(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildLabel("Name: ", "${widget.member['name']}"),
              buildLabel("Member ID: ", "${widget.member['member_id']}"),
              buildLabel("Due Amount: ", "${widget.member['due_amount']}"),
              buildLabel("Training Type: ", "${widget.member['training']}"),
              buildLabel("Plan: ", "${widget.member['member_plan']}"),
              buildLabel("Batch Time: ", "${widget.member['batch_time']}"),
              const SizedBox(height: 15),

              buildLabel("Measurements -:", ""),
              Row(
                children: [
                  buildMeasurementField(
                    controller: heightController,
                    label: "Height",
                  ),
                  buildMeasurementField(
                    controller: weightController,
                    label: "Weight",
                  ),
                ],
              ),
              Row(
                children: [
                  buildMeasurementField(
                    controller: chestController,
                    label: "Chest",
                  ),
                  buildMeasurementField(
                    controller: waistController,
                    label: "Waist",
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),

                child: Center(
                  child: ElevatedButton(
                    onPressed: updateMemberData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenAccent.withOpacity(0.5),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    iconButton(Icons.call, "Call"),
                    iconButton(Icons.message_outlined, "Whatsapp"),
                    iconButton(Icons.refresh, "Renew Plan"),
                    iconButton(Icons.message, "Message"),
                    iconButton(Icons.block, "Block"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String leftText, String rightText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          AutoSizeText(
            leftText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.greenAccent,
            ),
            maxLines: 1,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: AutoSizeText(
              rightText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMeasurementField({
    required TextEditingController controller,
    required String label,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label :",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.greenAccent,
              ),
            ),
            buildUnderlineTextField(
              controller: controller,
              inputType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUnderlineTextField({
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    int? maxLength,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLength: maxLength,
      readOnly: onTap != null,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        counterText: "",
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2),
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          AutoSizeText(
            "$label: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.greenAccent,
            ),
            maxLines: 1,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColors.greenAccent),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                filled: true,
                fillColor: Colors.black12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        AutoSizeText(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
          maxLines: 1,
        ),
      ],
    );
  }
}
