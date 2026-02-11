import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

Future printHtml(String htmlContent) async {
  print(htmlContent);
  await Printing.layoutPdf(
    format: PdfPageFormat(
      14.8 * PdfPageFormat.cm,
      21.0 * PdfPageFormat.cm,
    ),
    onLayout: (PdfPageFormat format) async {
      // ignore: deprecated_member_use
      return await Printing.convertHtml(
        format: format,
        html: htmlContent,
      );
    },
  );
}
