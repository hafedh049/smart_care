import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class FormTemplate extends pw.StatelessWidget {
  FormTemplate({required this.data});
  final List<dynamic> data;
  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      mainAxisSize: pw.MainAxisSize.min,
      children: <pw.Widget>[
        pw.SizedBox(height: 100),
        for (int index = 0; index < data.length; index++)
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: <pw.Widget>[
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(15), color: PdfColors.blue200),
                child: pw.Center(child: pw.Text(data[index], style: pw.TextStyle(fontSize: 32.0, fontWeight: pw.FontWeight.bold))),
              ),
              if (index != data.length - 2) pw.Center(child: pw.Container(width: 2, height: 50, color: PdfColors.blue200)),
            ],
          ),
      ],
    );
  }
}
