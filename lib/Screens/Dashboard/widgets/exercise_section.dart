import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubit/dashboard_cubit.dart';

class ExerciseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Exercise of the Day"),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.read<DashboardCubit>().addExercise(),
            ),
          ],
        ),
      ],
    );
  }
}
