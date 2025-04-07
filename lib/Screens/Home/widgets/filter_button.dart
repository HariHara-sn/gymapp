
// ----------------------------
// Filter Button Widget
// ----------------------------
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  const FilterButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        side: BorderSide(color: Colors.green),
      ),
      onPressed: () {},
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}
