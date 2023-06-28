import 'package:smart_care/models/virus_enum.dart';

class BloodTest {
  String timestamp;
  String patientId;
  VIRUS virusType;

  BloodTest({
    required this.timestamp,
    required this.patientId,
    required this.virusType,
  });

  factory BloodTest.fromJson(Map<String, dynamic> json) {
    return BloodTest(
      timestamp: json['timestamp'] as String,
      patientId: json['patientId'] as String,
      virusType: VIRUS.values[json['virusType'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'patientId': patientId,
      'virusType': virusType.index,
    };
  }
}
