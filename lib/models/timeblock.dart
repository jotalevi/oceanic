class TimeBlock {
  final String id;
  final String teacher;
  final String session;
  final String room;
  final String timeStart;
  final String timeEnd;
  final int timeStartSorter;
  final int weekday;

  TimeBlock({
    required this.id,
    required this.teacher,
    required this.session,
    required this.room,
    required this.timeStart,
    required this.timeEnd,
    required this.timeStartSorter,
    required this.weekday,
  });

  factory TimeBlock.fromJson(Map<String, dynamic> json) {
    return TimeBlock(
      id: json['id'],
      teacher: json['teacher'],
      session: json['session'],
      room: json['room'],
      timeStart: json['timeStart'],
      timeEnd: json['timeEnd'],
      timeStartSorter: int.parse(json['timeStart'].split(":")[0]) * 60 +
          int.parse(json['timeStart'].split(":")[1]),
      weekday: json['weekday'],
    );
  }

  static List<TimeBlock> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TimeBlock.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher': teacher,
      'session': session,
      'room': room,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'timeStartSorter': timeStartSorter,
      'weekday': weekday,
    };
  }

  double calculateTimeBefore(String before) {
    int startHr = int.parse(before.split(":")[0]);
    int startMn = int.parse(before.split(":")[1]);

    int endHr = int.parse(timeStart.split(":")[0]);
    int endMn = int.parse(timeStart.split(":")[1]);

    return double.parse(
        (((endHr * 60) + endMn) - ((startHr * 60) + startMn)).toString());
  }

  double calculateDuration() {
    int startHr = int.parse(timeStart.split(":")[0]);
    int startMn = int.parse(timeStart.split(":")[1]);

    int endHr = int.parse(timeEnd.split(":")[0]);
    int endMn = int.parse(timeEnd.split(":")[1]);

    return double.parse(
        (((endHr * 60) + endMn) - ((startHr * 60) + startMn)).toString());
  }

  double calculateTimeAfter(String after) {
    int startHr = int.parse(timeEnd.split(":")[0]);
    int startMn = int.parse(timeEnd.split(":")[1]);

    int endHr = int.parse(after.split(":")[0]);
    int endMn = int.parse(after.split(":")[1]);

    return double.parse(
        (((endHr * 60) + endMn) - ((startHr * 60) + startMn)).toString());
  }
}
