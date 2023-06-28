class Prescription {
  String doctorName;
  String patientName;
  String timestamp;

  Prescription({
    required this.doctorName,
    required this.patientName,
    required this.timestamp,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      doctorName: json['doctorName'] as String,
      patientName: json['patientName'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorName': doctorName,
      'patientName': patientName,
      'timestamp': timestamp,
    };
  }
}
