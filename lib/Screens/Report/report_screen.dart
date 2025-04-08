import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymapp/Screens/Report/widgets/shimmer_loader.dart';
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../Theme/appcolor.dart';

import 'cubit/report_cubit.dart';
import 'models/report_member_model.dart';
import 'widgets/data_table_widget.dart';

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});

//   @override
//   _ReportScreenState createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   final SupabaseClient supabase = Supabase.instance.client;
//   List<Map<String, dynamic>> members = [];
//   late final user = supabase.auth.currentUser;
//   bool isLoading = true;
//   bool isYearlyReport = false;

//   final List<String> months = [
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December',
//   ];

//   String? selectedMonth;

//   @override
//   void initState() {
//     super.initState();
//     fetchPayments();
//   }

//   Future<void> generatePDF() async {
//     final pdf = pw.Document();

//     final poppinsRegular = pw.Font.ttf(
//       await rootBundle.load("assets/fonts/Poppins-Medium.ttf"),
//     );
//     final poppinsBold = pw.Font.ttf(
//       await rootBundle.load("assets/fonts/Poppins-Bold.ttf"),
//     );

//     // Filter paid and pending members
//     List<Map<String, dynamic>> paidMembers =
//         members
//             .where((member) => member['payment_status'].startsWith('Paid'))
//             .toList();

//     int pendingCount =
//         members.where((member) => member['payment_status'] == 'Pending').length;

//     String monthText =
//         selectedMonth != null ? "Month: $selectedMonth" : "All Months";

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text(
//                 "Gym Payment Report",
//                 style: pw.TextStyle(
//                   fontSize: 24,
//                   fontWeight: pw.FontWeight.bold,
//                   font: poppinsBold,
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text(
//                 monthText,
//                 style: pw.TextStyle(fontSize: 18, font: poppinsRegular),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text(
//                 "Pending Payments: $pendingCount",
//                 style: pw.TextStyle(fontSize: 18, font: poppinsBold),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Table.fromTextArray(
//                 headers: ['S.No', 'Payment Method', 'Payment Status'],
//                 data:
//                     paidMembers.asMap().entries.map((entry) {
//                       int index = entry.key + 1;
//                       var member = entry.value;

//                       // Remove ✅ from payment_status
//                       String cleanStatus =
//                           member['payment_status'].replaceAll('✅', '').trim();

//                       return [
//                         index.toString(), // S.No
//                         member['payment_method'], // Payment Method
//                         cleanStatus, // Payment Status without emoji
//                       ];
//                     }).toList(),
//                 border: pw.TableBorder.all(),
//                 headerStyle: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   font: poppinsBold,
//                 ),
//                 cellAlignment: pw.Alignment.centerLeft,
//                 cellStyle: pw.TextStyle(font: poppinsRegular),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/report.pdf");
//     await file.writeAsBytes(await pdf.save());
//     OpenFile.open(file.path);
//   }

//   Future<void> fetchPayments({String? month, bool yearly = false}) async {
//     if (!mounted) return;
//     setState(() => isLoading = true);

//     try {
//       var query = supabase
//           .from('memberinfo')
//           .select('member_id, name, payment_method, payment_status')
//           .eq('gymId', user!.id);

//       if (month != null) {
//         String searchPattern = "-$month-${DateTime.now().year}";
//         int selectedMonth = int.parse(
//           month,
//         ); // Convert selected month to integer
//         int currentMonth = DateTime.now().month;

//         if (selectedMonth >= currentMonth) {
//           // Future or current month → Show both Paid ✅ and Pending ❌ members
//           query = query.or(
//             "payment_status.ilike.%$searchPattern%, payment_status.eq.Pending",
//           );
//         } else {
//           // Past month → Show only Paid ✅ members
//           query = query.ilike('payment_status', "%$searchPattern%");
//         }
//       } else {
//         // Default: Show all Paid ✅ + Pending ❌ members across all months
//         query = query.or(
//           "payment_status.ilike.Paid%, payment_status.eq.Pending",
//         );
//       }

//       final response = await query;
//       if (!mounted) return;
//       setState(() {
//         members = List<Map<String, dynamic>>.from(response);
//         isLoading = false;
//         isYearlyReport = yearly;
//       });
//     } catch (error) {
//       if (!mounted) return;
//       logger.e("Error fetching data: $error");
//       // CustomSnackBar.showSnackBar(
//       //   "Check Your Internet Connection",
//       //   SnackBarType.failure,
//       // );
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Reports & Analytics')),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: () => showMonthPicker(),
//                 style: ElevatedButton.styleFrom(
//                   side: BorderSide(color: Colors.white),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                 ),
//                 child: Text(
//                   "Monthly Report",
//                   style: TextStyle(color: AppColors.greenAccent),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   side: BorderSide(color: Colors.white),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                 ),
//                 onPressed: () => fetchPayments(),
//                 child: Text(
//                   "Yearly Report",
//                   style: TextStyle(color: AppColors.greenAccent),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child:
//                 isLoading
//                     ? ShimmerLoader()
//                     : PaymentDataTable(members: members),
//           ),
//           ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 side: BorderSide(color: AppColors.greenAccent),
//               ),
//             ),
//             onPressed: () => generatePDF(),
//             icon: Icon(Icons.download, color: AppColors.greenAccent),
//             label: Text(
//               'Download the Report',
//               style: TextStyle(color: AppColors.white),
//             ),
//           ),
//           SizedBox(height: 50),
//         ],
//       ),
//     );
//   }

//   void showMonthPicker() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Select Month"),
//           content: DropdownButton<String>(
//             value: selectedMonth,
//             hint: Text("Select Month"),
//             items: [
//               DropdownMenuItem<String>(
//                 value: "All Months",
//                 child: Text("All Months"),
//               ),
//               ...months.map((String month) {
//                 return DropdownMenuItem<String>(
//                   value: month,
//                   child: Text(month),
//                 );
//               }),
//             ],
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 if (!mounted) return;
//                 setState(() {
//                   selectedMonth = newValue;
//                   // logger.i("Selected Month: $selectedMonth");
//                   if (newValue == "All Months") {
//                     fetchPayments(month: null); // Fetch all months
//                   } else {
//                     fetchPayments(
//                       month: (months.indexOf(newValue) + 1).toString().padLeft(
//                         2,
//                         '',
//                       ),
//                     );
//                   }
//                 });
//                 Navigator.pop(context);
//               }
//             },
//           ),
//         );
//       },
//     );
//   }

//   }

import 'package:flutter_bloc/flutter_bloc.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ReportCubit(supabase: Supabase.instance.client)..fetchPayments(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Reports & Analytics')),
        body: BlocConsumer<ReportCubit, ReportState>(
          listener: (context, state) {
            if (state is ReportError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<ReportCubit>();

            if (state is ReportLoading) {
              return const ShimmerLoader();
            }

            if (state is ReportLoaded) {
              return Column(
                children: [
                  _buildReportTypeSelector(context, cubit),
                  const SizedBox(height: 10),
                  Expanded(
                    child: PaymentDataTable(
                      members:
                          state.report.members.map((m) => m.toJson()).toList(),
                    ),
                  ),
                  _buildDownloadButton(context, state.report),
                  const SizedBox(height: 50),
                ],
              );
            }

            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector(BuildContext context, ReportCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => _showMonthPicker(context, cubit),
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
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
            side: const BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          onPressed: () => cubit.fetchPayments(yearly: true),
          child: Text(
            "Yearly Report",
            style: TextStyle(color: AppColors.greenAccent),
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context, Report report) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.greenAccent),
        ),
      ),
      onPressed: () => _generatePDF(context, report),
      icon: Icon(Icons.download, color: AppColors.greenAccent),
      label: Text(
        'Download the Report',
        style: TextStyle(color: AppColors.white),
      ),
    );
  }

  void _showMonthPicker(BuildContext context, ReportCubit cubit) {
    final months = [
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Month"),
          content: DropdownButton<String>(
            hint: const Text("Select Month"),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text("All Months"),
              ),
              ...months.map((String month) {
                return DropdownMenuItem<String>(
                  value: (months.indexOf(month) + 1).toString().padLeft(2, '0'),
                  child: Text(month),
                );
              }),
            ],
            onChanged: (String? month) {
              Navigator.pop(context);
              cubit.fetchPayments(month: month);
            },
          ),
        );
      },
    );
  }

  Future<void> _generatePDF(BuildContext context, Report report) async {
    final pdf = await PdfGenerator.generateReportPdf(report);
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter/services.dart';
// import '../models/report_model.dart';

class PdfGenerator {
  static Future<pw.Document> generateReportPdf(Report report) async {
    final pdf = pw.Document();

    final poppinsRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Medium.ttf"),
    );
    final poppinsBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Poppins-Bold.ttf"),
    );

    String monthText =
        report.month != null
            ? "Month: ${_getMonthName(int.parse(report.month!))}"
            : "All Months";

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
                "Pending Payments: ${report.pendingCount}",
                style: pw.TextStyle(fontSize: 18, font: poppinsBold),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['S.No', 'Payment Method', 'Payment Status'],
                data:
                    report.members
                        .where((m) => m.paymentStatus.startsWith('Paid'))
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                          int index = entry.key + 1;
                          var member = entry.value;
                          return [
                            index.toString(),
                            member.paymentMethod,
                            member.paymentStatus.replaceAll('✅', '').trim(),
                          ];
                        })
                        .toList(),
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

    return pdf;
  }

  static String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}

//add on below the fetchmetho
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
