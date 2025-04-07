import 'package:flutter/material.dart';
import 'package:gymapp/Screens/Home/widgets/memberinfo_widget.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberCard extends StatelessWidget {
  final String phone;
  final String name;
  final String memberId;
  final String planExpiry;
  final String dueAmount;
  final String profilePic;
  final VoidCallback onDelete; // Callback for deletion

  const MemberCard({
    super.key,
    required this.phone,
    required this.name,
    required this.memberId,
    required this.planExpiry,
    required this.dueAmount,
    required this.profilePic,
    required this.onDelete,
  });

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this member?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancel", style: TextStyle(color: AppColors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete(); // Call the deletion function
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: AppColors.greenAccent, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture and Delete Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(profilePic),
              ),
              IconButton(
                onPressed: () => showDeleteConfirmationDialog(context),
                icon: Icon(
                  Icons.delete,
                  color: Colors.white.withOpacity(0.5),
                  size: 25,
                ),
              ),
            ],
          ),

          Spacer(),

          // Member Details
          MemberinfoWidget(placeholder: 'Name', value: name),
          MemberinfoWidget(placeholder: 'M ID', value: memberId),
          MemberinfoWidget(placeholder: 'Plan Expiry', value: planExpiry),
          MemberinfoWidget(placeholder: 'Due Amount', value: dueAmount),

          Spacer(),

          // Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => makePhoneCall(phone),
                child: Icon(Icons.call, color: Colors.white, size: 18),
              ),
              Icon(Icons.message, color: Colors.white, size: 18),
              Icon(Icons.phone_android, color: Colors.white, size: 18),
              Icon(Icons.assignment, color: Colors.white, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
