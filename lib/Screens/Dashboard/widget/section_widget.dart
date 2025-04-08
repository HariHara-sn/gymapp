import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Theme/appcolor.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, TextEditingController>> items;
  final String type;
  final VoidCallback onAdd;
  final Function(int) onDelete;
  final Function(int, String, String) onChanged;

  const SectionWidget({
    super.key,
    required this.title,
    required this.items,
    required this.type,
    required this.onAdd,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                TextField(
                  controller:
                      items[index]['exercise_title'] ??
                      items[index]['notice_title'],
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),

                  decoration: InputDecoration(
                    labelText: "Title",

                    hintText: "Enter title",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged:
                      (value) => onChanged(
                        index,
                        value,
                        (items[index]['exercise_desc'] ??
                                items[index]['notice_desc'])!
                            .text,
                      ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller:
                      items[index]['exercise_desc'] ??
                      items[index]['notice_desc'],
                  maxLines: 3,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),

                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Enter description",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 18,

                      color: AppColors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged:
                      (value) => onChanged(
                        index,
                        (items[index]['exercise_title'] ??
                                items[index]['notice_title'])!
                            .text,
                        value,
                      ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => onDelete(index),
                    child: const Text(
                      "Remove",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ],
    );
  }
}
