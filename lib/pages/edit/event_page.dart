import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oceanic_teachers/models/event.dart';
import 'package:oceanic_teachers/models/session.dart';

import 'package:oceanic_teachers/utils/event_types.dart';
import 'package:intl/intl.dart';

class EditEventPage extends StatefulWidget {
  final bool isNewEvent;
  final Event event;
  const EditEventPage(
      {super.key, required this.event, this.isNewEvent = false});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController descriptionController;
  late TextEditingController titleController;
  late DateTime dateTimeStart;
  late String sessionId;
  late int durationMinutes;
  late int weekday;
  late int type;
  late bool canSave;

  @override
  initState() {
    canSave = false;
    super.initState();
    if (widget.isNewEvent) {
      type = 0;
      titleController = TextEditingController();
      descriptionController = TextEditingController();
      dateTimeStart = DateTime.now();
      weekday = dateTimeStart.weekday;
      durationMinutes = 15;
      sessionId = widget.event.session;
    } else {
      type = widget.event.type;
      titleController = TextEditingController(text: widget.event.title);
      descriptionController =
          TextEditingController(text: widget.event.description);
      dateTimeStart = widget.event.date;
      weekday = widget.event.weekday;
      durationMinutes = widget.event.durationMinutes;
      sessionId = widget.event.session;
    }
  }

  bool _canSave() {
    if (widget.isNewEvent) {
      return titleController.text.isNotEmpty && sessionId.isNotEmpty;
    } else {
      return titleController.text.isNotEmpty;
    }
  }

  save() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Event e = Event(
      id: widget.event.id,
      type: type,
      title: titleController.text,
      teacher: FirebaseAuth.instance.currentUser!.uid,
      session: sessionId,
      description: descriptionController.text,
      date: dateTimeStart,
      weekday: weekday,
      durationMinutes: durationMinutes,
      timeStartSorter: dateTimeStart.millisecondsSinceEpoch,
    );

    if (widget.isNewEvent) {
      firestore.collection('events').doc(e.id).set(e.toJson());
    } else {
      firestore.collection('events').doc(e.id).update(e.toJson());
    }

    Navigator.pop(context);
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.darkBackgroundGray,
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('sessions')
            .where('teacher', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          List<Session> sessions = [];

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            for (final session in snapshot.data!.docs) {
              sessions.add(
                  Session.fromJson(session.data() as Map<String, dynamic>));
            }
          }

          if (sessions.isEmpty) {
            sessions.add(Session(
              id: sessionId,
              code: '',
              name: '',
              teacher: '',
              color: 2,
            ));
          }

          return Container(
            color: CupertinoColors.darkBackgroundGray,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 40,
              ),
              child: Column(
                children: [
                  Text(
                    widget.isNewEvent ? 'Crear Evento' : 'Editar Evento',
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoTextField(
                    placeholder: 'Nombre del evento',
                    controller: titleController,
                    maxLength: 24,
                    maxLines: 1,
                    cursorColor: CupertinoColors.white,
                    placeholderStyle: TextStyle(
                      color: CupertinoColors.white.withOpacity(0.5),
                    ),
                    style: const TextStyle(
                      color: CupertinoColors.white,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onChanged: (String _) {
                      if (canSave != _canSave()) {
                        setState(() {
                          canSave = _canSave();
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoTextField(
                    placeholder: 'Descripción del evento',
                    controller: descriptionController,
                    maxLines: 3,
                    cursorColor: CupertinoColors.white,
                    placeholderStyle: TextStyle(
                      color: CupertinoColors.white.withOpacity(0.5),
                    ),
                    style: const TextStyle(
                      color: CupertinoColors.white,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onChanged: (String _) {
                      if (canSave != _canSave()) {
                        setState(() {
                          canSave = _canSave();
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () {
                        _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 34,
                            scrollController: FixedExtentScrollController(
                              initialItem: type,
                            ),
                            // This is called when selected item is changed.
                            onSelectedItemChanged: (int selectedItem) {
                              setState(() {
                                type = selectedItem;
                                canSave = _canSave();
                              });
                            },
                            children: List<Widget>.generate(
                              6,
                              (int index) {
                                return Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      EventType.prettyStr(
                                        EventType.fromInt(
                                          index,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: EventType.color(
                                          EventType.fromInt(
                                            index,
                                          ),
                                        ),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Icon(
                                        EventType.icon(
                                          EventType.fromInt(index),
                                        ),
                                        size: 20,
                                        color: EventType.color(
                                          EventType.fromInt(
                                            index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 34,
                        color: CupertinoColors.white.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Tipo de evento:",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    EventType.prettyStr(
                                      EventType.fromInt(
                                        type,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: EventType.color(
                                        EventType.fromInt(
                                          type,
                                        ),
                                      ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Icon(
                                      EventType.icon(
                                        EventType.fromInt(type),
                                      ),
                                      size: 20,
                                      color: EventType.color(
                                        EventType.fromInt(
                                          type,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () {
                        _showDialog(
                          CupertinoDatePicker(
                            onDateTimeChanged: (_) {
                              setState(() {
                                dateTimeStart = _;
                                canSave = _canSave();
                              });
                            },
                            mode: CupertinoDatePickerMode.dateAndTime,
                            showDayOfWeek: false,
                            use24hFormat: true,
                            initialDateTime: dateTimeStart,
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 34,
                        color: CupertinoColors.white.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Fecha y Hora de Inicio:",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yy HH:mm')
                                    .format(dateTimeStart),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () {
                        _showDialog(
                          CupertinoTimerPicker(
                            mode: CupertinoTimerPickerMode.hm,
                            initialTimerDuration:
                                Duration(minutes: durationMinutes),
                            minuteInterval: 5,
                            onTimerDurationChanged: (Duration value) {
                              setState(() {
                                durationMinutes = value.inMinutes;
                                canSave = _canSave();
                              });
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 34,
                        color: CupertinoColors.white.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Duración del Evento:",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                '${int.parse((durationMinutes / 60).toString().split('.')[0])}hr ${durationMinutes % 60}min',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () {
                            canSave ? save() : null;
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            color: canSave
                                ? Colors.blue
                                : Colors.white.withOpacity(0.2),
                            child: Center(
                              child: Text(
                                "Guardar",
                                style: TextStyle(
                                  color: CupertinoColors.white
                                      .withOpacity(canSave ? 1 : 0.5),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
