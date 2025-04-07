import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/main.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../../Theme/appcolor.dart';
import '../Utils/custom_snack_bar.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> members = [];
  late final user = supabase.auth.currentUser;
  bool isLoading = true;

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

  Future<void> fetchPayments({String? month}) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      var query = supabase
          .from('memberinfo')
          .select('member_id, name, payment_method, payment_status')
          .eq('gymId', user!.id);

      /// below logic is for dispaly both paid and pending mem on all months
      // if (month != null) {
      //   // Extract month-year pattern from payment_status (dd-mm-yyyy)
      //   String searchPattern = "-$month-${DateTime.now().year}";

      //   // query = query.ilike('payment_status', "%$searchPattern%");  this line only fetch the paid members
      //   query = query.or(
      //     "payment_status.ilike.%$searchPattern%, payment_status.eq.Pending",
      //   );
      // }
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

      setState(() {
        members = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });

    } catch (error) {
      if (!mounted) return;
      logger.e("Error fetching data: $error");
      CustomSnackBar.showSnackBar(
        "Check Your Internet Connection",
        SnackBarType.failure,
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePaymentStatus(String memberId, String newStatus) async {
    try {
      String formattedDate = DateFormat('d-M-yyyy').format(DateTime.now());
      String updatedStatus =
          newStatus == "✅ Paid" ? "Paid ✅ $formattedDate" : "Pending";

      await supabase
          .from('memberinfo')
          .update({'payment_status': updatedStatus})
          .eq('member_id', memberId);

      fetchPayments(month: selectedMonth); // Refresh data after update
    } catch (error) {
      logger.e("Error updating payment status: $error");
    }
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    final poppinsRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Medium.ttf"),
    );
    final poppinsBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Bold.ttf"),
    );

    // Filter members to include only 'Paid' status
    List<Map<String, dynamic>> paidMembers =
        members
            .where((member) => member['payment_status'].startsWith('Paid'))
            .toList();

    String monthText =
        selectedMonth != null ? "Month: $selectedMonth" : "All Months";

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Gym Collection",
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

    // Save and Share PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/report.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'report.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Gym Collection',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.white),
            onPressed: generatePDF, // Calls the updated function
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search by Month:",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedMonth,
                    hint: Text("Select Month"),
                    items:
                        months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (!mounted) return; // ✅ CHECK before calling setState

                      setState(() {
                        selectedMonth = newValue;
                        fetchPayments(
                          month: (months.indexOf(newValue!) + 1)
                              .toString()
                              .padLeft(2, ''),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading ? _buildShimmerEffect() : _buildDataTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundColor.withOpacity(0.5),
      highlightColor: Colors.grey[50]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder:
            (context, index) => Container(
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

  Widget _buildDataTable() {
    final double width = MediaQuery.of(context).size.width;
    double mq = 0;

    if (width < 600) {
      // Mobile Screen
      mq = 25;
    } else if (width >= 600 && width < 1024) {
      // Tablet Screen
      mq = 150;
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
              'Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Payment Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.greenAccent,
              ),
            ),
          ),
        ],
        rows:
            members.map((member) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      member['name'],
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                  DataCell(
                    Text(
                      member['payment_method'],
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                  DataCell(
                    DropdownButton<String>(
                      value:
                          member['payment_status'].startsWith('Paid')
                              ? '✅ Paid'
                              : 'Not Paid',
                      items:
                          ['✅ Paid', 'Not Paid']
                              .map(
                                (status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          updatePaymentStatus(member['member_id'], newValue);
                        }
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
