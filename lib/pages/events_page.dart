import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oceanic_teachers/models/event.dart';
import 'package:oceanic_teachers/widgets/event_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where(
              'teacher',
              isEqualTo: FirebaseAuth.instance.currentUser?.uid,
            )
            .where('timeStartSorter',
                isGreaterThanOrEqualTo: DateTime.now()
                    .subtract(
                      const Duration(
                        hours: 12,
                      ),
                    )
                    .millisecondsSinceEpoch)
            .orderBy('timeStartSorter')
            .snapshots(),
        builder: (context, snapshot) {
          List<Widget> eventsToday = [
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Hoy",
                    ),
                  ],
                ),
              ],
            ),
          ];
          List<Widget> eventsThisWeek = [
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Esta semana",
                    ),
                  ],
                ),
              ],
            ),
          ];
          List<Widget> eventsThisMonth = [
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Este mes",
                    ),
                  ],
                ),
              ],
            ),
          ];
          List<Widget> afterThisMonth = [
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Más adelante",
                    ),
                  ],
                ),
              ],
            ),
          ];

          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            for (final eventDoc in snapshot.data!.docs) {
              final eventData = eventDoc.data() as Map<String, dynamic>;

              final Event event = Event.fromJson(
                eventData,
              );

              if (event.date.day == DateTime.now().day &&
                  event.date.month == DateTime.now().month) {
                eventsToday.addAll([
                  Divider(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  EventCard(event: event)
                ]);
              } else {
                if (event.date.millisecondsSinceEpoch <=
                    DateTime.now()
                        .add(const Duration(days: 7))
                        .millisecondsSinceEpoch) {
                  eventsThisWeek.addAll([
                    Divider(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    EventCard(event: event)
                  ]);
                } else if (event.date.month == DateTime.now().month &&
                    event.date.year == DateTime.now().year) {
                  eventsThisMonth.addAll([
                    Divider(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    EventCard(event: event)
                  ]);
                } else {
                  afterThisMonth.addAll([
                    Divider(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    EventCard(event: event)
                  ]);
                }
              }
            }

            if (eventsToday.length == 1) {
              eventsToday.add(
                Center(
                  child: Text(
                    'No tienes eventos programados para hoy.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(
                        0.75,
                      ),
                    ),
                  ),
                ),
              );
            }

            if (eventsThisWeek.length == 1) {
              eventsThisWeek.add(
                Center(
                  child: Text(
                    'No tienes eventos programados para esta semana.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(
                        0.75,
                      ),
                    ),
                  ),
                ),
              );
            }

            if (eventsThisMonth.length == 1) {
              eventsThisMonth = [];
            }

            if (afterThisMonth.length == 1) {
              afterThisMonth = [];
            }

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: ListView(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 60, bottom: 300),
                children: [
                  ...eventsToday,
                  const SizedBox(height: 20),
                  ...eventsThisWeek,
                  const SizedBox(height: 20),
                  ...eventsThisMonth,
                  const SizedBox(height: 20),
                  ...afterThisMonth,
                ],
              ),
            );
          }

          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
