import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oceanic_teachers/models/session.dart';
import 'package:oceanic_teachers/models/timeblock.dart';
import 'package:oceanic_teachers/utils/month.dart';
import 'package:oceanic_teachers/utils/weekday.dart';
import 'package:oceanic_teachers/widgets/timeblock.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('timeblocks')
          .where(
            'weekday',
            isEqualTo: DateTime.now().weekday,
          )
          .where(
            'teacher',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .orderBy('timeStartSorter')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          List<Widget> sessionsWidgets = [];

          for (final tb in snapshot.data!.docs) {
            final TimeBlock timeBlock =
                TimeBlock.fromJson(tb.data() as Map<String, dynamic>);

            sessionsWidgets.add(
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('sessions')
                    .doc(timeBlock.session)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active &&
                      snapshot.hasData) {
                    final Session session = Session.fromJson(
                        snapshot.data!.data() as Map<String, dynamic>);

                    return TimeBlockCard(
                      timeBlock: timeBlock,
                      session: session,
                    );
                  }

                  return const SizedBox();
                },
              ),
            );
          }

          sessionsWidgets.addAll(
            [
              sessionsWidgets.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'No tienes ninguna classe hoy.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(
                            0.5,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          );

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateTime.now().day} de ${monthStrFromInt(DateTime.now().month)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        weekDayStr(DateTime.now().weekday),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ...sessionsWidgets,
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
      },
    );
  }
}
