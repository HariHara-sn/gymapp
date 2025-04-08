import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  const PageIndicator({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index ? Colors.greenAccent : Colors.grey,
            ),
          );
        }),
      ),
    );
  }
}
