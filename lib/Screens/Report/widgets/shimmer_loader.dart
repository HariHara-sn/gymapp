import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Theme/appcolor.dart';


class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundColor.withOpacity(0.5),
      highlightColor: Colors.grey[50]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
