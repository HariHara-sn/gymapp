import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generatePDF(
      List<Map<String, dynamic>> members, String? selectedMonth) async {
    final pdf = pw.Document();

    final poppinsRegular =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Poppins-Medium.ttf"));
    final poppinsBold =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Poppins-Medium.ttf"));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Gym Payment Report",
                style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold, font: poppinsBold),
              ),
              pw.SizedBox(height: 10),
              if (selectedMonth != null)
                pw.Text("Month: $selectedMonth",
                    style: pw.TextStyle(fontSize: 18, font: poppinsRegular)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Name', 'Payment Method', 'Paid Amount'],
                data: members.map((member) => [
                      member['name'],
                      member['payment_method'],
                      "₹ ${member['paid_amount']}",
                    ]).toList(),
                border: pw.TableBorder.all(),
                headerStyle:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, font: poppinsBold),
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

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'report.pdf');
  }
}
