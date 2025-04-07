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
          // style: TextStyle(
          //   fontSize: 20,
          //   fontWeight: FontWeight.bold,
          //   color: Colors.black,
          // ),
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

// import 'package:flutter/material.dart';

// class MemberDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> member;

//   const MemberDetailsPage({super.key, required this.member});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text(
//           "Member Information",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.delete, color: Colors.black),
//             onPressed: () {
//               // Delete function here
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundImage: NetworkImage(
//                       member['member_img'] ?? "https://picsum.photos/200",
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "Name: ${member['name']}",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(color: Colors.green),
//             infoRow(Icons.badge, "M ID", member['member_id'].toString()),
//             infoRow(Icons.date_range, "Plan Expiry", "01 Sep 2023"),
//             infoRow(
//               Icons.attach_money,
//               "Due Amount",
//               member['due_amount'].toString(),
//             ),

//             SizedBox(height: 8),
//             Text(
//               "Training:",
//               style: TextStyle(
//                 color: Colors.green,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Row(
//               children: [
//                 Radio(
//                   value: "Trainer",
//                   groupValue: "Trainer",
//                   onChanged: (value) {},
//                 ),
//                 Text("Trainer", style: TextStyle(color: Colors.white)),
//                 SizedBox(width: 20),
//                 Radio(
//                   value: "Personal",
//                   groupValue: "Trainer",
//                   onChanged: (value) {},
//                 ),
//                 Text("Personal", style: TextStyle(color: Colors.white)),
//               ],
//             ),

//             infoRow(Icons.fitness_center, "Plan", "General [800]"),
//             infoRow(Icons.access_time, "Batch Time", "6.00am to 7.00am"),

//             SizedBox(height: 10),
//             Text(
//               "Measurement:",
//               style: TextStyle(
//                 color: Colors.green,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Height: .......", style: TextStyle(color: Colors.white)),
//                 Text("Weight: .......", style: TextStyle(color: Colors.white)),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Chest: .......", style: TextStyle(color: Colors.white)),
//                 Text("Waist: .......", style: TextStyle(color: Colors.white)),
//               ],
//             ),

//             SizedBox(height: 10),
//             Text(
//               "Add Information:",
//               style: TextStyle(
//                 color: Colors.green,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.green),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: TextField(
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: "Enter details",
//                   hintStyle: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             ),

//             SizedBox(height: 16),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//                   child: Text(
//                     "Save",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 iconButton(Icons.call, "Call"),
//                 iconButton(Icons.message_outlined, "Whatsapp"),
//                 iconButton(Icons.refresh, "Renew Plan"),
//                 iconButton(Icons.message, "Message"),
//                 iconButton(Icons.block, "Block"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget infoRow(IconData icon, String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.green, size: 20),
//           SizedBox(width: 8),
//           Text(
//             "$title: ",
//             style: TextStyle(
//               color: Colors.green,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// }
