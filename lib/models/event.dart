import 'dart:math';

class Event {
  final String id;
  final int type;
  final String title;
  final String teacher;
  final String session;
  final String description;
  final DateTime date;
  final int weekday;
  final int durationMinutes;
  final int timeStartSorter;

  Event({
    required this.id,
    required this.type,
    required this.title,
    required this.teacher,
    required this.session,
    required this.description,
    required this.date,
    required this.weekday,
    required this.durationMinutes,
    required this.timeStartSorter,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      type: json['type'],
      title: json['title'],
      teacher: json['teacher'],
      session: json['session'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      weekday: min(json['weekday'], 6),
      durationMinutes: json['durationMinutes'],
      timeStartSorter: json['timeStartSorter'],
    );
  }

  static List<Event> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Event.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'teacher': teacher,
      'session': session,
      'description': description,
      'date': date.toIso8601String(),
      'weekday': min(weekday, 6),
      'durationMinutes': durationMinutes,
      'timeStartSorter': timeStartSorter,
    };
  }
}
