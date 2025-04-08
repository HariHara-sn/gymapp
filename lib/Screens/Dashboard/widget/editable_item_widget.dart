// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EditableItemWidget extends StatefulWidget {
//   final int index;
//   final Map<String, dynamic> item;
//   final String type;
//   final VoidCallback onDelete;
//   final Function(Map<String, dynamic>) onChanged;

//   const EditableItemWidget({
//     super.key,
//     required this.index,
//     required this.item,
//     required this.type,
//     required this.onDelete,
//     required this.onChanged,
//   });

//   @override
//   State<EditableItemWidget> createState() => _EditableItemWidgetState();
// }

// class _EditableItemWidgetState extends State<EditableItemWidget> {
//   late TextEditingController _titleController;
//   late TextEditingController _descController;

//   @override
//   void initState() {
//     super.initState();
//     final isExercise = widget.type == "exercise";
//     _titleController = TextEditingController(
//       text: widget.item[isExercise ? "exercise_title" : "notice_title"] ?? "",
//     );
//     _descController = TextEditingController(
//       text: widget.item[isExercise ? "exercise_desc" : "notice_desc"] ?? "",
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isExercise = widget.type == "exercise";

//     return Column(
//       children: [
//         TextField(
//           controller: _titleController,
//           style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
//           onChanged: (value) {
//             widget.item[isExercise ? "exercise_title" : "notice_title"] = value;
//             widget.onChanged(widget.item);
//           },
//           decoration: InputDecoration(
//             labelText: "Title",
//             hintStyle: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//             hintText: "Title",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//         const SizedBox(height: 10),
//         TextFormField(
//           controller: _descController,
//           maxLines: 3,
//           onChanged: (value) {
//             widget.item[isExercise ? "exercise_desc" : "notice_desc"] = value;
//             widget.onChanged(widget.item);
//           },
//           decoration: InputDecoration(
//             hintText: "Enter details...",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: widget.onDelete,
//             child: const Text("Remove", style: TextStyle(color: Colors.red)),
//           ),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }