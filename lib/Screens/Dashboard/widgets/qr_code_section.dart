import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../logic/cubit/dashboard_cubit.dart';
import '../../../logic/cubit/dashboard_state.dart';


class QRCodeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is! DashboardLoaded) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("UPI QR Code", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Center(
              child: QrImageView(
                data: state.qrReference,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: state.upiId,
              decoration: const InputDecoration(labelText: "UPI ID"),
              onChanged: (value) => context.read<DashboardCubit>().updateUPI(value, state.amount),
            ),
            TextFormField(
              initialValue: state.amount,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
              onChanged: (value) => context.read<DashboardCubit>().updateUPI(state.upiId, value),
            ),
          ],
        );
      },
    );
  }
}
