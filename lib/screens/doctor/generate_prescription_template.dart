import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrescriptionTemplate extends pw.StatelessWidget {
  PrescriptionTemplate({required this.patientData});
  final Map<String, dynamic> patientData;
  @override
  pw.Widget build(pw.Context context) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
            children: <pw.Widget>[
              pw.Text("Rx", style: pw.TextStyle(fontSize: 64.0, fontWeight: pw.FontWeight.bold)),
              pw.Spacer(),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: <pw.Widget>[
                  pw.Text("PATIENT NAME: ${patientData['patientName']}", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(height: 10.0),
                  pw.Text("D.O.B: ${patientData['dob'].toDate().toString().substring(0, 10).replaceAll(" ", "").replaceAll("-", " / ")}", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(height: 10.0),
                  pw.Text("S. No: ${patientData['title']}", style: const pw.TextStyle(fontSize: 18.0)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 30.0),
          pw.Row(children: <pw.Widget>[pw.Expanded(child: pw.Container(height: 2, color: PdfColors.black))]),
          pw.SizedBox(height: 30.0),
          pw.Expanded(child: pw.Text("(Rx) Diagnosis:\n${patientData['diagnosis']}", style: pw.TextStyle(fontSize: 24.0, fontWeight: pw.FontWeight.bold))),
          pw.Spacer(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: <pw.Widget>[
              pw.Flexible(child: pw.Text("Take ${patientData['takes']},", style: const pw.TextStyle(fontSize: 18.0))),
              pw.SizedBox(width: 10.0),
              pw.Text("${patientData['times']} times, per", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['perDay'] == "Day" ? true : false, name: "Day"),
              pw.SizedBox(width: 5.0),
              pw.Text("Day", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['perDay'] == "Week" ? true : false, name: "Week"),
              pw.SizedBox(width: 5.0),
              pw.Text("Week", style: const pw.TextStyle(fontSize: 18.0)),
            ],
          ),
          pw.SizedBox(height: 20.0),
          pw.Text("Days of the week", style: const pw.TextStyle(fontSize: 18.0)),
          pw.SizedBox(height: 10.0),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: <pw.Widget>[
              pw.Checkbox(value: patientData['listOfDays']['Mon'], name: "Mon"),
              pw.SizedBox(width: 5.0),
              pw.Text("Mon", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['listOfDays']['Tue'], name: "Tue"),
              pw.SizedBox(width: 5.0),
              pw.Text("Tue", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['listOfDays']['Wed'], name: "Wed"),
              pw.SizedBox(width: 5.0),
              pw.Text("Wed", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['listOfDays']['Thu'], name: "Thu"),
              pw.SizedBox(width: 5.0),
              pw.Text("Thu", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['listOfDays']['Fri'], name: "Fri"),
              pw.SizedBox(width: 5.0),
              pw.Text("Fri", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['listOfDays']['Sat'], name: "Sat"),
              pw.SizedBox(width: 5.0),
              pw.Text("Sat", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['listOfDays']['Sun'], name: "Sun"),
              pw.SizedBox(width: 5.0),
              pw.Text("Sun", style: const pw.TextStyle(fontSize: 18.0)),
            ],
          ),
          pw.SizedBox(height: 20.0),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text("Frequency", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['frequencies']['Morning'], name: "Morning"),
              pw.SizedBox(width: 5.0),
              pw.Text("Morning", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['frequencies']['Noon'], name: "Noon"),
              pw.SizedBox(width: 5.0),
              pw.Text("Noon", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(width: 10.0),
              pw.Checkbox(value: patientData['frequencies']['Night'], name: "Night"),
              pw.SizedBox(width: 5.0),
              pw.Text("Night", style: const pw.TextStyle(fontSize: 18.0)),
            ],
          ),
          pw.SizedBox(height: 40.0),
          pw.Text(patientData['doctorName'].toUpperCase(), style: pw.TextStyle(fontSize: 24.0, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10.0),
          pw.Text(patientData['doctorSpeciality'], style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10.0),
          pw.Text("ID: ${patientData['doctorID']}", style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 30.0),
          pw.Row(children: <pw.Widget>[pw.Expanded(child: pw.Container(height: 2, color: PdfColors.black))]),
          pw.SizedBox(height: 30.0),
          pw.Row(
            children: <pw.Widget>[
              pw.Text("SIGNATURE: _______________________", style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(width: 40.0),
              pw.Text("DATE: ${DateTime.now().toString().substring(0, 10).replaceAll(" ", "").replaceAll("-", " / ")}", style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
