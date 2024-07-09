import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oceanic_teachers/models/session.dart';
import 'package:oceanic_teachers/pages/edit/session_page.dart';
import 'package:oceanic_teachers/widgets/session_card.dart';
import 'package:uuid/uuid.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sessions')
            .where(
              'teacher',
              isEqualTo: FirebaseAuth.instance.currentUser?.uid,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            List<Widget> sessionsWidgets = [];

            for (final session in snapshot.data!.docs) {
              final sessionData = session.data() as Map<String, dynamic>;

              sessionsWidgets.add(
                SessionCard(
                  session: Session.fromJson(sessionData),
                ),
              );
            }

            sessionsWidgets.addAll([
              const SizedBox(height: 20),
              sessionsWidgets.isEmpty
                  ? Center(
                      child: Text(
                        'No tienes ninguna sección creada',
                        style: TextStyle(
                          color: Colors.white.withOpacity(
                            0.75,
                          ),
                        ),
                      ),
                    )
                  : Container(),

              // Add a button to create a new session
              const SizedBox(height: 20),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: GestureDetector(
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return EditSessionPage(
                              session: Session(
                                  id: const Uuid().v4(),
                                  name: '',
                                  code: '',
                                  teacher:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  color: 0),
                              isNewSession: true);
                        },
                      );
                    },
                    child: Container(
                      width: 75,
                      height: 75,
                      color: Colors.white.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.add,
                          color: Colors.white.withOpacity(0.75),
                          size: 55,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]);

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: ListView(
                children: [
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
        });
  }
}
