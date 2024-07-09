import 'package:oceanic_teachers/models/event.dart';
import 'package:oceanic_teachers/models/session.dart';
import 'package:oceanic_teachers/models/timeblock.dart';

class DataMan {}

class TeacherData {
  final List<TimeBlock> timeBlocks;
  final List<Event> events;
  final List<Session> sessions;

  TeacherData({
    required this.timeBlocks,
    required this.events,
    required this.sessions,
  });
}
