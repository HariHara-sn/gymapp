import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Utils/member_form_utils.dart';
import '../../../widgets/build_text.dart';
import '../../../widgets/build_underline_text.dart';

class EmploymentPaymentPage extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController employerController;
  final TextEditingController occupationController;
  final TextEditingController fromJoiningDateController;
  final TextEditingController toJoiningDateController;
  final TextEditingController memberPlanController;
  final TextEditingController paymentMethodController;
  final TextEditingController paidAmountController;
  final TextEditingController paidDateController;
  final TextEditingController dueAmountController;

  const EmploymentPaymentPage({
    super.key,
    required this.emailController,
    required this.employerController,
    required this.occupationController,
    required this.fromJoiningDateController,
    required this.toJoiningDateController,
    required this.memberPlanController,
    required this.paymentMethodController,
    required this.paidAmountController,
    required this.paidDateController,
    required this.dueAmountController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText("Email -:"),
          BuildUnderlineText(controller: emailController),

          BuildText("Employer -:"),
          BuildUnderlineText(controller: employerController),

          BuildText("Occupation -:"),
          BuildUnderlineText(controller: occupationController),

          BuildText("Joining Date -:"),
          Row(
            children: [
              Expanded(
                child: BuildUnderlineText(
                  controller: fromJoiningDateController,
                  onTap: () => MemberFormUtils.selectDate(context, fromJoiningDateController),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "To",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BuildUnderlineText(
                  controller: toJoiningDateController,
                  onTap: () => MemberFormUtils.selectDate(context, toJoiningDateController),
                ),
              ),
            ],
          ),

          BuildText("Plan -:"),
          BuildUnderlineText(controller: memberPlanController),

          BuildText("Payment Method -:"),
          BuildUnderlineText(controller: paymentMethodController),

          BuildText("Paid Amount -:"),
          BuildUnderlineText(
            controller: paidAmountController,
            inputType: TextInputType.number,
          ),

          BuildText("Paid Date -:"),
          BuildUnderlineText(
            controller: paidDateController,
            onTap: () => MemberFormUtils.selectDate(context, paidDateController),
          ),

          BuildText("Due Amount -:"),
          BuildUnderlineText(
            controller: dueAmountController,
            inputType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}