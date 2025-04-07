import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubit/dashboard_cubit.dart';
import '../../../logic/cubit/dashboard_state.dart';


class NoticeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is! DashboardLoaded) return const SizedBox.shrink();
        final notices = state.notices;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Notices", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => context.read<DashboardCubit>().addNotice(),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notices.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: TextFormField(
                      initialValue: notices[index].title,
                      decoration: const InputDecoration(labelText: "Notice Title"),
                      onChanged: (value) {
                        notices[index].title = value;
                      },
                    ),
                    subtitle: TextFormField(
                      initialValue: notices[index].description,
                      decoration: const InputDecoration(labelText: "Notice Description"),
                      onChanged: (value) {
                        notices[index].description = value;
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
