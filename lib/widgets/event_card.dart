import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oceanic_teachers/models/event.dart';
import 'package:oceanic_teachers/models/session.dart';
import 'package:oceanic_teachers/pages/edit/event_page.dart';
import 'package:oceanic_teachers/utils/colors.dart';
import 'package:oceanic_teachers/utils/format_duration.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('sessions')
          .doc(event.session)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            enabled: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Cargando',
                      style: TextStyle(
                        fontSize: 16,
                        color: defaultThemeColors.last,
                      ),
                    ),
                    const Text(
                      ' - evento',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('dd/MM/yyyy').format(event.date)} a las ${DateFormat('HH:mm').format(event.date)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          CupertinoIcons.clock,
                          color: Colors.white.withOpacity(0.5),
                          size: 14,
                        ),
                        Text(
                          ' ${formatDuration(event.durationMinutes)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
        }

        final session =
            Session.fromJson(snapshot.data?.data() as Map<String, dynamic>);

        return GestureDetector(
          onTap: () {
            showCupertinoModalBottomSheet(
              context: context,
              builder: (context) {
                return EditEventPage(event: event);
              },
            );
          },
          child: Container(
            color: Colors.white.withOpacity(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: defaultThemeColors[session.color],
                      ),
                    ),
                    Text(
                      ' - ${event.title}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('dd/MM/yyyy').format(event.date)} a las ${DateFormat('HH:mm').format(event.date)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          CupertinoIcons.clock,
                          color: Colors.white.withOpacity(0.5),
                          size: 14,
                        ),
                        Text(
                          ' ${formatDuration(event.durationMinutes)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
