class Appointment {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime date;
  final String time;
  final bool approved;
  final bool statusUpdated;

  Appointment(
      {required this.id,
      required this.doctorId,
      required this.patientId,
      required this.date,
      required this.time,
      required this.approved,
      required this.statusUpdated});

  // Method to convert Appointment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'date': date.toIso8601String(),
      'time': time,
      'approved': approved,
      'statusUpdated': statusUpdated
    };
  }

  // Method to create Appointment from JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json['id'],
        doctorId: json['doctorId'],
        patientId: json['patientId'],
        date: DateTime.parse(json['date']),
        time: json['time'],
        approved: json['approved'] ?? false,
        statusUpdated: json['statusUpdated'] ?? false);
  }
}
