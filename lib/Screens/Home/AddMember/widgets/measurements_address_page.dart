import 'package:flutter/material.dart';

import '../../../../Utils/member_form_utils.dart';
import '../../../widgets/build_measurementfield.dart';
import '../../../widgets/build_radio_button.dart';
import '../../../widgets/build_text.dart';
import '../../../widgets/build_underline_text.dart';

class MeasurementsAddressPage extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController chestController;
  final TextEditingController waistController;
  final TextEditingController addressController;
  final TextEditingController batchTimeController;
  final String trainingType;
  final Function(String) onTrainingChanged;

  const MeasurementsAddressPage({
    super.key,
    required this.heightController,
    required this.weightController,
    required this.chestController,
    required this.waistController,
    required this.addressController,
    required this.batchTimeController,
    required this.trainingType,
    required this.onTrainingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText("Measurements -:"),
          Row(
            children: [
              MeasurementField(
                controller: heightController,
                label: "Height",
              ),
              MeasurementField(
                controller: weightController,
                label: "Weight",
              ),
            ],
          ),
          Row(
            children: [
              MeasurementField(
                controller: chestController,
                label: "Chest",
              ),
              MeasurementField(
                controller: waistController,
                label: "Waist",
              ),
            ],
          ),

          BuildText("Address -:"),
          BuildUnderlineText(controller: addressController),

          BuildText("Training -:"),
          Row(
            children: [
              BuildRadioButton(
                value: "Trainer",
                icon: Icons.directions_run,
                groupValue: trainingType,
                onChanged: onTrainingChanged,
              ),
              BuildRadioButton(
                value: "Personal",
                icon: Icons.person_rounded,
                groupValue: trainingType,
                onChanged: onTrainingChanged,
              ),
            ],
          ),

          BuildText("Batch Time -:"),
          BuildUnderlineText(
            controller: batchTimeController,
            onTap: () => MemberFormUtils.selectTime(context, batchTimeController),
          ),
        ],
      ),
    );
  }
}