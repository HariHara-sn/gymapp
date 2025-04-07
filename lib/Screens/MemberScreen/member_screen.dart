import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../Utils/data_cleaner.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final supabase = Supabase.instance.client;

  String exerciseTitle = "Loading...";
  String exerciseDesc = "Loading...";
  String noticeTitle = "Loading...";
  String noticeDesc = "Loading...";
  String upiId = "Loading...";
  String amount = "0";
  List<Map<String, dynamic>> exerciseData = [];
  List<Map<String, dynamic>> noticeData = [];
  String? qrReference;

  @override
  void initState() {
    super.initState();
     checkAndDeleteOldRecords();
    _fetchWorkoutData();
    _fetchUPIData();
  }

  Future<void> _fetchWorkoutData() async {
    try {
      final exerciseResponse = await supabase
          .from('gym_dashboard')
          .select()
          .order('created_at', ascending: false);

      final noticeResponse = await supabase
          .from('gym_notices')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        exerciseData = List<Map<String, dynamic>>.from(exerciseResponse);
        noticeData = List<Map<String, dynamic>>.from(noticeResponse);
      });
    } catch (e) {
      debugPrint("Error fetching workout/notice data: $e");
    }
  }

  Future<void> _fetchUPIData() async {
    try {
      final response =
          await supabase
              .from('payment_qr')
              .select()
              .order('created_at', ascending: false)
              .single();

      setState(() {
        upiId = response['upi_id'] ?? "Loading...";
        amount = response['amount']?.toString() ?? "0";
      });
      _generateQRCode();
    } catch (e) {
      debugPrint("Error fetching UPI data: $e");
    }
  }

  void _generateQRCode() {
    setState(() {
      qrReference = "upi://pay?pa=$upiId&am=$amount&cu=INR";
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gym Title
            Text(
              '360 Gym',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
            ),

            const SizedBox(height: 5),

            // Date
            Text(
              formattedDate,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.white),
            ),

            // Exercise of the Day
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Text(
                'Exercise of the Day',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greenAccent,
                ),
              ),
            ),

            exerciseData.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true, // To avoid unbounded height issues
                  physics:
                      NeverScrollableScrollPhysics(), // Disable scrolling inside ScrollView
                  itemCount: exerciseData.length,
                  itemBuilder: (context, index) {
                    final data = exerciseData[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['exercise_title'] ?? "No event today",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenAccent,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data['exercise_desc'] ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  },
                )
                : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "No event today",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ),
            Text(
              'Important Notices',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
            ),

            const SizedBox(height: 10),

            noticeData.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: noticeData.length,
                  itemBuilder: (context, index) {
                    final data = noticeData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: NoticeCard(
                        title: data['notice_title'] ?? "No event today",
                        description: data['notice_desc'] ?? "",
                        date: formattedDate,
                      ),
                    );
                  },
                )
                : NoticeCard(
                  title: "No event today",
                  description: "",
                  date: formattedDate,
                ),

            const SizedBox(height: 20),

            // Quick Payment Section
            QuickPaymentCard(
              upiId: upiId,
              amount: amount,
            qrReference: qrReference.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

// Notice Card Widget
class NoticeCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const NoticeCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.greenAccent,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.white),
          ),
          const SizedBox(height: 5),
          Text(
            date,
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

// Quick Payment Card Widget
class QuickPaymentCard extends StatelessWidget {
  final String upiId;
  final String amount;
  final String qrReference;

  const QuickPaymentCard({
    super.key,
    required this.upiId,
    required this.amount,
    required this.qrReference,
  });
  Future<void> _openGPay() async {
    // String upiUrl = "upi://pay?pa=sudhanabirami007-1@okhdfcbank&pn=Hari%20Hara%20Sudhan&am=100&cu=INR"; //limit to 100
    // String upiUrl = "upi://pay?pa=sudhanabirami007-1@okhdfcbank&pn=Hari%20Hara%20Sudhan&cu=INR";
    // String upiUrl =  "upi://pay?${Secrets.upiId}&pn=Hari%20Hara%20Sudhan&cu=INR"; // with name
    // String upiUrl = "upi://pay?$upiId&cu=INR"; // without name

    Uri uri = Uri.parse(qrReference);

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareQRCode(BuildContext context) async {
    try {
      final qrPainter = QrPainter(
        data: qrReference,
        version: QrVersions.auto,
        color: Colors.black,
        emptyColor: Colors.white,
      );

      // Convert to image
      final picData = await qrPainter.toImageData(250);
      if (picData == null) return;

      final buffer = picData.buffer;
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/gpay_qr_code.png').writeAsBytes(
        buffer.asUint8List(picData.offsetInBytes, picData.lengthInBytes),
      );

      // Share the QR code
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Scan this QR code to pay me:\nUPI ID: sudhanabirami007-1@okhdfcbank',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR Code: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 15,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Quick Payment',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                QrImageView(
                  data: qrReference, // Updated QR Code data
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  'Scan to Pay',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹$amount',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'UPI ID: $upiId',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.payment, size: 24, color: AppColors.white),
            label: Text(
              'Pay via GPay',
              style: TextStyle(fontSize: 18, color: AppColors.greenAccent),
            ),
            onPressed: () => _openGPay(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.share, size: 24, color: AppColors.white),
            label: Text(
              'Share QR Code',
              style: TextStyle(fontSize: 18, color: AppColors.greenAccent),
            ),
            onPressed: () => _shareQRCode(context),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 33, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
