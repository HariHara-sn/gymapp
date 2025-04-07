import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
import 'package:gymapp/main.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Theme/appcolor.dart' show AppColors;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../Utils/data_cleaner.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> exerciseData = [];
  List<Map<String, dynamic>> noticeData = [];
  List<Map<String, dynamic>> gymData = [];

  final supabase = Supabase.instance.client;
  final uuid = Uuid();

  String upiId = '';
  String amount = '0';
  late String qrReference;

  @override
  void initState() {
    super.initState();
     checkAndDeleteOldRecords(); //daily check for any old data exists
    _generateQRCode();
    _fetchPaymentDetails();
  }

  Future<void> _fetchPaymentDetails() async {
    try {
      final response = await supabase
          .from('payment_qr')
          .select()
          .order('created_at', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        if (!mounted) return;
        final paymentData = response[0];
        setState(() {
          upiId = paymentData['upi_id'] ?? '';
          amount = paymentData['amount']?.toString() ?? '0';
          qrReference = "upi://pay?pa=$upiId&am=$amount&cu=INR";
        });
      }
    } catch (e) {
      if (!mounted) return;
      logger.e('Error fetching payment details: $e');
    }
  }

  Future<void> _saveDataToSupabase() async {
    try {
      // Add UUID and created_at to each exercise item
      final List<Map<String, dynamic>> formattedExercises =
          exerciseData.map((e) {
            return {
              "id": uuid.v4(),
              "exercise_title": e["exercise_title"],
              "exercise_desc": e["exercise_desc"],
              "created_at": DateTime.now().toIso8601String(),
            };
          }).toList();

      final List<Map<String, dynamic>> formattedNotices =
          noticeData.map((e) {
            return {
              "id": uuid.v4(),
              "notice_title": e["notice_title"],
              "notice_desc": e["notice_desc"],
              "created_at": DateTime.now().toIso8601String(),
            };
          }).toList();

      await supabase.from('gym_exercises').insert(formattedExercises).select();
      await supabase.from('gym_notices').insert(formattedNotices).select();

      if (mounted) {
        CustomSnackBar.showSnackBar(
          'Data saved successfully!',
          SnackBarType.success,
        );
      }
    } catch (e) {
      logger.e('Supabase insert error: $e');
      if (mounted) {
        CustomSnackBar.showSnackBar('Error saving data', SnackBarType.failure);
      }
    }
  }

  Future<void> _updateUPIDetails(String newUpi, String newAmount) async {
    if (!mounted) return;
    try {
      setState(() {
        upiId = newUpi;
        amount = newAmount;
      });

      final paymentData = {
        'id': uuid.v4(),
        'upi_id': newUpi,
        'amount': newAmount,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response =
          await supabase.from('payment_qr').insert(paymentData).select();

      if (response.isEmpty) {
        throw Exception("Insert failed or no response received.");
      }

      if (mounted) {
        CustomSnackBar.showSnackBar(
          'UPI details updated successfully!',
          SnackBarType.success,
        );
        _generateQRCode();
      }
    } catch (e) {
      if (!mounted) return;
      logger.e('Supabase upi error: $e');
      if (mounted) {
        CustomSnackBar.showSnackBar(
          'Error updating UPI details',
          SnackBarType.failure,
        );
      }
    }
  }

  void _generateQRCode() {
    if (!mounted) return;
    setState(() {
      qrReference = "upi://pay?pa=$upiId&am=$amount&cu=INR";
    });
  }

  void _showQRUpdateBottomSheet() {
    TextEditingController upiController = TextEditingController(text: upiId);
    TextEditingController amountController = TextEditingController(
      text: amount,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            // logger.f("keyboard height: $keyboardHeight");

            return FractionallySizedBox(
              heightFactor: keyboardHeight > 0 ? 0.8 : 0.5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1667,
                      height: 2,
                      color: AppColors.white,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    Text(
                      'Update UPI Details',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // UPI ID Input
                    TextField(
                      controller: upiController,
                      decoration: InputDecoration(
                        labelText: "Enter UPI ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Amount Input
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Update Button
                    ElevatedButton(
                      onPressed: () async {
                        if (upiController.text.isNotEmpty ||
                            amountController.text.isNotEmpty) {
                          await _updateUPIDetails(
                            upiController.text,
                            amountController.text,
                          );

                          Navigator.pop(context);
                        } else {
                          CustomSnackBar.showSnackBar(
                            "Please fill the fields",
                            SnackBarType.failure,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "Update QR Code",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Gym Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise of the Day section
            _buildSection(
              title: 'Exercise of the Day',
              items: exerciseData,
              type: 'exercise',
              onAdd: () {
                if (!mounted) return;
                setState(() {
                  exerciseData.add({"exercise_title": "", "exercise_desc": ""});
                });
              },
            ),

            const Divider(height: 40),

            // Gym Notices section
            _buildSection(
              title: 'Gym Notices',
              items: noticeData,
              type: 'notice',
              onAdd: () {
                if (!mounted) return;
                setState(() {
                  noticeData.add({"notice_title": "", "notice_desc": ""});
                });
              },
            ),

            const Divider(height: 40),

            // Gym QR Code section
            Text(
              'Gym QR Code',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // QR Code
                      QrImageView(
                        data: qrReference, // Updated QR Code data
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      // Display the reference below QR Code
                      Text(
                        "Scan to Pay or Access Gym",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AutoSizeText(
                        "UPI ID: $upiId",
                        style: GoogleFonts.poppins(
                          fontSize:
                              MediaQuery.of(context).size.width *
                              0.04, // 4% of screen width
                          fontWeight: FontWeight.bold,
                          color: AppColors.greenAccent,
                        ),
                        maxLines: 1,
                        minFontSize:
                            12, // Ensures text does not become too small
                        overflow:
                            TextOverflow
                                .ellipsis, // Handles overflow gracefully
                      ),

                      Text(
                        "Amount: ₹$amount",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: OutlinedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.15,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _showQRUpdateBottomSheet,
                  icon: Icon(Icons.qr_code, color: AppColors.greenAccent),
                  label: Text(
                    'Generate New QR',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => _saveDataToSupabase(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    backgroundColor: AppColors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Save Data",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section builder for exercises and notices
  Widget _buildSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required VoidCallback onAdd,
    required String type, // 'exercise' or 'notice'
  }) {
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
            return _buildTextFields(
              index: index,
              items: items,
              type: type,
              onDelete: () {
                if (!mounted) return;
                setState(() {
                  items.removeAt(index);
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextFields({
    required int index,
    required List<Map<String, dynamic>> items,
    required VoidCallback onDelete,
    required String type, // 'exercise' or 'notice'
  }) {
    final isExercise = type == "exercise";

    return Column(
      children: [
        TextField(
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          onChanged: (value) {
            items[index][isExercise ? "exercise_title" : "notice_title"] =
                value;
          },
          decoration: InputDecoration(
            labelText: "Title",
            hintStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            hintText: "Title",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          maxLines: 3,
          onChanged: (value) {
            items[index][isExercise ? "exercise_desc" : "notice_desc"] = value;
          },

          decoration: InputDecoration(
            hintText: "Enter details...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onDelete,
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
