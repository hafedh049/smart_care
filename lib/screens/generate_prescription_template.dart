import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrescriptionTemplate extends pw.StatelessWidget {
  PrescriptionTemplate({required this.pageWidth, required this.pageHeight});
  final double pageWidth;
  final double pageHeight;
  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Container(
          height: 100,
          color: PdfColors.teal,
          padding: const pw.EdgeInsets.all(12.0),
          child: pw.Center(
            child: pw.Text("MEDICAL CENTER : COMPANY NAME", style: pw.TextStyle(fontSize: 24.0, fontWeight: pw.FontWeight.bold)),
          ),
        ),
        pw.SizedBox(height: 160.0),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 36.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: <pw.Widget>[
              pw.Center(child: pw.Text(doctorName, style: pw.TextStyle(fontSize: 24.0, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 10.0),
              pw.Center(child: pw.Text(speciality, style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 10.0),
              pw.Center(child: pw.Text("ID: $id", style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 20.0),
              pw.Row(
                children: <pw.Widget>[
                  pw.Text("S. No: __________________", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.Spacer(),
                  pw.Text("Date: ${datePrescription.toString().substring(0, 10)}", style: const pw.TextStyle(fontSize: 18.0)),
                ],
              ),
              pw.SizedBox(height: 10.0),
              pw.Text("Patient's Name: $patientName", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(height: 10.0),
              pw.Row(
                children: <pw.Widget>[
                  pw.Text("DOB: ${dob.toString().substring(0, 10)}", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.Spacer(),
                  pw.Text("Age: $age", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.Spacer(),
                  pw.Text("Gender: $gender", style: const pw.TextStyle(fontSize: 18.0)),
                ],
              ),
              pw.SizedBox(height: 30.0),
              pw.Text("(Rx) Diagnosis: $diagnosis", style: pw.TextStyle(fontSize: 24.0, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10.0),
              pw.Flexible(child: pw.Text("_________________________________________________________", style: const pw.TextStyle(fontSize: 18.0))),
              pw.SizedBox(height: 20.0),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Flexible(child: pw.Text("Take _____", style: const pw.TextStyle(fontSize: 18.0))),
                  pw.SizedBox(width: 10.0),
                  pw.Text("____ times per", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Day"),
                  pw.SizedBox(width: 5.0),
                  pw.Text("Day", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Week"),
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
                  pw.Checkbox(value: false, name: "Mon"),
                  pw.SizedBox(width: 5.0),
                  pw.Text("Mon", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Tue"),
                  pw.SizedBox(width: 5.0),
                  pw.Text("Tue", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Wed"),
                  pw.SizedBox(width: 5.0),
                  pw.Text("Wed", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Thu"),
                  pw.SizedBox(width: 5.0),
                  pw.Text("Thu", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Fri"),
                  pw.SizedBox(width: 5.0),
                  pw.Text("Fri", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Sat"),
                  pw.SizedBox(width: 5.0),
                  pw.Text("Sat", style: const pw.TextStyle(fontSize: 18.0)),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Sun"),
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
                  pw.Checkbox(value: false, name: "Morning"),
                  pw.SizedBox(width: 5.0),
                  pw.Text("Morning"),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Noon"),
                  pw.SizedBox(width: 5.0),
                  pw.Text("Noon"),
                  pw.SizedBox(width: 10.0),
                  pw.Checkbox(value: false, name: "Night"),
                  pw.Text("Night"),
                  pw.SizedBox(width: 5.0),
                ],
              ),
              pw.SizedBox(height: 40.0),
              pw.Text("_______________________", style: const pw.TextStyle(fontSize: 18.0)),
              pw.SizedBox(height: 20.0),
              pw.Text("Doctor's Signature", style: const pw.TextStyle(fontSize: 18.0)),
            ],
          ),
        ),
        pw.Spacer(),
        pw.Container(
          height: 100,
          color: PdfColors.teal,
          child: pw.Footer(
            margin: pw.EdgeInsets.zero,
            title: pw.Text("MEDICAL CARE CLINIC NAME", style: const pw.TextStyle(fontSize: 18.0)),
          ),
        ),
      ],
    );
  }
}

// Define the doctor's name, speciality, and ID
const String doctorName = "Dr. John Smith";
const String speciality = "Cardiologist";
const String id = "123456";

// Define the patient's name and date of prescription
const String patientName = "Jane Doe";
final DateTime datePrescription = DateTime.now();

// Define the patient's date of birth, age, and gender
final DateTime dob = DateTime(1990, 6, 1);
final int age = DateTime.now().difference(dob).inDays ~/ 365;
const String gender = "Female";

// Define the diagnosis
const String diagnosis = "Hypertension";
