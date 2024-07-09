import 'package:flutter/material.dart';
import 'package:oceanic_teachers/pages/events_page.dart';
import 'package:oceanic_teachers/pages/schedule_page.dart';
import 'package:oceanic_teachers/pages/sessions_page.dart';
import 'package:oceanic_teachers/pages/settings_page.dart';
import 'package:oceanic_teachers/pages/today_page.dart';

List<Widget> homeScreenItems = const [
  TodayPage(),
  EventsPage(),
  SessionsPage(),
  ScheduleViewPage(),
  SettingsPage(),
];
