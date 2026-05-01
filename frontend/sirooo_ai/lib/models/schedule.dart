class Schedule {
  final int? id;
  final String name;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final String eventType;

  Schedule({
    this.id,
    required this.name,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.eventType,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      location: json['location'],
      eventType: json['event_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'date': date.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'location': location,
      'event_type': eventType,
    };
  }
}
