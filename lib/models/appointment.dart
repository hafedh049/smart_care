class AppointmentModel {
  String patientName;
  String doctorName;
  String appointmentDate;
  String duration;

  AppointmentModel({
    required this.patientName,
    required this.doctorName,
    required this.appointmentDate,
    required this.duration,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      patientName: json['patientName'] as String,
      doctorName: json['doctorName'] as String,
      appointmentDate: json['appointmentDate'] as String,
      duration: json['duration'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'doctorName': doctorName,
      'appointmentDate': appointmentDate,
      'duration': duration,
    };
  }
}
