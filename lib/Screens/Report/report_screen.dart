import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
import 'package:gymapp/main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../Theme/appcolor.dart';
import 'package:open_file/open_file.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> members = [];
  late final user = supabase.auth.currentUser;
  bool isLoading = true;
  bool isYearlyReport = false;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    final poppinsRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Medium.ttf"),
    );
    final poppinsBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Bold.ttf"),
    );

    // Filter paid and pending members
    List<Map<String, dynamic>> paidMembers =
        members
            .where((member) => member['payment_status'].startsWith('Paid'))
            .toList();

    int pendingCount =
        members.where((member) => member['payment_status'] == 'Pending').length;

    String monthText =
        selectedMonth != null ? "Month: $selectedMonth" : "All Months";

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Gym Payment Report",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  font: poppinsBold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                monthText,
                style: pw.TextStyle(fontSize: 18, font: poppinsRegular),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "Pending Payments: $pendingCount",
                style: pw.TextStyle(fontSize: 18, font: poppinsBold),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['S.No', 'Payment Method', 'Payment Status'],
                data:
                    paidMembers.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      var member = entry.value;

                      // Remove ✅ from payment_status
                      String cleanStatus =
                          member['payment_status'].replaceAll('✅', '').trim();

                      return [
                        index.toString(), // S.No
                        member['payment_method'], // Payment Method
                        cleanStatus, // Payment Status without emoji
                      ];
                    }).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: poppinsBold,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: pw.TextStyle(font: poppinsRegular),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/report.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }

  /// below is for dispaly both paid and pending mem on all months
  // Future<void> fetchPayments({String? month, bool yearly = false}) async {
  //   setState(() => isLoading = true);

  //   try {
  //     var query = supabase
  //         .from('memberinfo')
  //         .select('member_id, name, payment_method, payment_status')
  //         .eq('gymId', user!.id);

  //     if (month != null) {
  //       String searchPattern = "-$month-${DateTime.now().year}";

  //       query = query.or(
  //         "payment_status.ilike.%$searchPattern%, payment_status.eq.Pending",
  //       );
  //     }
  //     final response = await query;
  //     logger.i(response);

  //     setState(() {
  //       members = List<Map<String, dynamic>>.from(response);
  //       isLoading = false;
  //       isYearlyReport = yearly;
  //     });
  //   } catch (error) {
  //     logger.e("Error fetching data: $error");
  //     CustomSnackBar.showSnackBar(
  //       "Check Your Internet Connection",
  //       SnackBarType.failure,
  //     );
  //     setState(() => isLoading = false);
  //   }
  // }

  Future<void> fetchPayments({String? month, bool yearly = false}) async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      var query = supabase
          .from('memberinfo')
          .select('member_id, name, payment_method, payment_status')
          .eq('gymId', user!.id);

      if (month != null) {
        String searchPattern = "-$month-${DateTime.now().year}";
        int selectedMonth = int.parse(
          month,
        ); // Convert selected month to integer
        int currentMonth = DateTime.now().month;

        if (selectedMonth >= currentMonth) {
          // Future or current month → Show both Paid ✅ and Pending ❌ members
          query = query.or(
            "payment_status.ilike.%$searchPattern%, payment_status.eq.Pending",
          );
        } else {
          // Past month → Show only Paid ✅ members
          query = query.ilike('payment_status', "%$searchPattern%");
        }
      } else {
        // Default: Show all Paid ✅ + Pending ❌ members across all months
        query = query.or(
          "payment_status.ilike.Paid%, payment_status.eq.Pending",
        );
      }

      final response = await query;
      if (!mounted) return;
      setState(() {
        members = List<Map<String, dynamic>>.from(response);
        isLoading = false;
        isYearlyReport = yearly;
      });
    } catch (error) {
      if (!mounted) return;
      logger.e("Error fetching data: $error");
      CustomSnackBar.showSnackBar(
        "Check Your Internet Connection",
        SnackBarType.failure,
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports & Analytics')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => showMonthPicker(),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: Text(
                  "Monthly Report",
                  style: TextStyle(color: AppColors.greenAccent),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                onPressed: () => fetchPayments(),
                child: Text(
                  "Yearly Report",
                  style: TextStyle(color: AppColors.greenAccent),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: isLoading ? _buildShimmerEffect() : _buildDataTable(context),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.greenAccent),
              ),
            ),
            onPressed: () => generatePDF(),
            icon: Icon(Icons.download, color: AppColors.greenAccent),
            label: Text(
              'Download the Report',
              style: TextStyle(color: AppColors.white),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  void showMonthPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Month"),
          content: DropdownButton<String>(
            value: selectedMonth,
            hint: Text("Select Month"),
            items: [
              DropdownMenuItem<String>(
                value: "All Months",
                child: Text("All Months"),
              ),
              ...months.map((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                if (!mounted) return;
                setState(() {
                  selectedMonth = newValue;
                  // logger.i("Selected Month: $selectedMonth");
                  if (newValue == "All Months") {
                    fetchPayments(month: null); // Fetch all months
                  } else {
                    fetchPayments(
                      month: (months.indexOf(newValue) + 1).toString().padLeft(
                        2,
                        '',
                      ),
                    );
                  }
                });
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundColor.withOpacity(0.5),
      highlightColor: Colors.grey[50]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder:
            (context, index) => Container(
              padding: EdgeInsets.all(10),
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

  Widget _buildDataTable(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    double mq = 0;

    if (width < 600) {
      // Mobile Screen
      mq = 60;
    } else if (width >= 600 && width < 1024) {
      // Tablet Screen
      mq = 200;
    } else {
      // Larger Screens (Desktop)
      mq = 300;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: mq,
        dividerThickness: 0.5,
        columns: [
          DataColumn(
            label: Text(
              'Payment Method',
              style: TextStyle(color: AppColors.greenAccent),
            ),
          ),
          DataColumn(
            label: Text(
              'Payment Status',
              style: TextStyle(color: AppColors.greenAccent),
            ),
          ),
        ],
        rows:
            members.map((member) {
              return DataRow(
                cells: [
                  DataCell(Text(member['payment_method'])),
                  DataCell(Text(member['payment_status'])),
                ],
              );
            }).toList(),
      ),
    );
  }
}
