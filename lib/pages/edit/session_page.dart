import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oceanic_teachers/models/event.dart';
import 'package:oceanic_teachers/models/session.dart';
import 'package:oceanic_teachers/models/timeblock.dart';
import 'package:oceanic_teachers/pages/edit/event_page.dart';
import 'package:oceanic_teachers/pages/edit/timeblock_page.dart';
import 'package:oceanic_teachers/utils/colors.dart';
import 'package:oceanic_teachers/utils/weekday.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class EditSessionPage extends StatefulWidget {
  final bool isNewSession;
  final Session session;
  const EditSessionPage(
      {super.key, required this.session, this.isNewSession = false});

  @override
  State<EditSessionPage> createState() => _EditSessionPageState();
}

class _EditSessionPageState extends State<EditSessionPage> {
  late TextEditingController nameController;
  late TextEditingController codeController;
  late bool canSave;
  late int color;

  @override
  initState() {
    super.initState();

    canSave = false;
    color = widget.session.color;
    nameController = TextEditingController(text: widget.session.name);
    codeController = TextEditingController(text: widget.session.code);
  }

  bool _canSave() {
    if (widget.isNewSession) {
      return nameController.text.isNotEmpty && codeController.text.isNotEmpty;
    } else {
      return nameController.text.isNotEmpty &&
          codeController.text.isNotEmpty &&
          (nameController.text != widget.session.name ||
              codeController.text != widget.session.code ||
              color != widget.session.color);
    }
  }

  deleteSession() {
    FirebaseFirestore.instance
        .collection('sessions')
        .doc(widget.session.id)
        .delete();

    FirebaseFirestore.instance
        .collection('timeblocks')
        .where(
          'session',
          isEqualTo: widget.session.id,
        )
        .get()
        .then((value) {
      for (final tb in value.docs) {
        FirebaseFirestore.instance.collection('timeblocks').doc(tb.id).delete();
      }
    });

    FirebaseFirestore.instance
        .collection('events')
        .where(
          'session',
          isEqualTo: widget.session.id,
        )
        .get()
        .then((value) {
      for (final ev in value.docs) {
        FirebaseFirestore.instance.collection('events').doc(ev.id).delete();
      }
    });
    Navigator.pop(context);
  }

  save() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Session s = Session(
      id: widget.session.id,
      name: nameController.text,
      code: codeController.text,
      color: color,
      teacher: FirebaseAuth.instance.currentUser!.uid,
    );

    if (widget.isNewSession) {
      firestore.collection('sessions').doc(s.id).set(s.toJson());
    } else {
      firestore.collection('sessions').doc(s.id).update(s.toJson());
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    CupertinoIcons.back,
                    color: CupertinoColors.white.withOpacity(0.5),
                  ),
                ),
                Text(
                  widget.isNewSession ? 'Nueva Sessión' : 'Editar Sessión',
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  color: CupertinoColors.white,
                                  child: Center(
                                    child: QrImageView(
                                      data:
                                          'https://oceanic.share.app/s/${widget.session.id}',
                                      version: QrVersions.auto,
                                      size: 275.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Icon(
                    CupertinoIcons.share,
                    color: CupertinoColors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoTextField(
              placeholder: 'Nombre de la Sessión',
              controller: nameController,
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
                if (_canSave() != canSave) {
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
              placeholder: 'Codigo de la sección',
              controller: codeController,
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
                if (_canSave() != canSave) {
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
                      // This sets the initial item.
                      scrollController: FixedExtentScrollController(
                        initialItem: color,
                      ),
                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        if (canSave != _canSave()) {
                          setState(() {
                            canSave = _canSave();
                          });
                        } else {
                          setState(() {
                            color = selectedItem;
                          });
                        }
                      },
                      children: List<Widget>.generate(
                        defaultThemeColors.length,
                        (int index) {
                          return Center(
                            child: Text(
                              defaultThemeNamesSpanish[index],
                              style: TextStyle(
                                color: defaultThemeColors[index],
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          );
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
                          "Color",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          '${defaultThemeNamesSpanish[color]} >',
                          style: TextStyle(
                            color: defaultThemeColors[color],
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
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: CupertinoColors.white.withOpacity(0.2),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('timeblocks')
                          .where(
                            'session',
                            isEqualTo: widget.session.id,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active &&
                            snapshot.hasData) {
                          List<Widget> children = [];

                          for (final tb in snapshot.data!.docs) {
                            final tbData = tb.data() as Map<String, dynamic>;
                            TimeBlock timeBlock = TimeBlock.fromJson(tbData);

                            children.add(
                              Dismissible(
                                key: Key(timeBlock.id),
                                secondaryBackground: Container(
                                  color: CupertinoColors.systemRed,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 7,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          CupertinoIcons.trash,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                background: Container(
                                  color: CupertinoColors.systemGreen,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 7,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(CupertinoIcons.pencil),
                                      ],
                                    ),
                                  ),
                                ),
                                confirmDismiss: (_) {
                                  if (_ == DismissDirection.endToStart) {
                                    return Future.delayed(Duration.zero, () {
                                      return true;
                                    });
                                  } else {
                                    if (_ == DismissDirection.startToEnd) {
                                      showCupertinoModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return EditTimeBlockPage(
                                            timeBlock: timeBlock,
                                            isNewTimeBlock: false,
                                          );
                                        },
                                      );
                                    }

                                    return Future.delayed(Duration.zero, () {
                                      return false;
                                    });
                                  }
                                },
                                onDismissed: (_) {
                                  if (_ == DismissDirection.endToStart) {
                                    FirebaseFirestore.instance
                                        .collection('timeblocks')
                                        .doc(timeBlock.id)
                                        .delete();
                                  }
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${weekDayStr(timeBlock.weekday)}  ${timeBlock.timeStart} - ${timeBlock.timeEnd} [${timeBlock.room}]',
                                          style: const TextStyle(
                                            color: CupertinoColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: children,
                          );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Esta sección no tiene clases asignadas",
                              style: TextStyle(
                                color: CupertinoColors.white.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return EditTimeBlockPage(
                            timeBlock: TimeBlock(
                              id: const Uuid().v4(),
                              teacher: FirebaseAuth.instance.currentUser!.uid,
                              session: widget.session.id,
                              room: '',
                              timeStart: '12:00',
                              timeEnd: '13:00',
                              timeStartSorter: 1200,
                              weekday: min(DateTime.now().weekday, 6),
                            ),
                            isNewTimeBlock: true,
                          );
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 34,
                      color: CupertinoColors.white.withOpacity(0.2),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Crear Clase",
                              style: TextStyle(
                                color: CupertinoColors.activeBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
                      color:
                          canSave ? Colors.blue : Colors.white.withOpacity(0.2),
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
            const SizedBox(
              height: 80,
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return EditEventPage(
                        event: Event(
                          id: const Uuid().v4(),
                          session: widget.session.id,
                          title: '',
                          description: '',
                          durationMinutes: 60,
                          teacher: FirebaseAuth.instance.currentUser!.uid,
                          type: 0,
                          date: DateTime.now(),
                          weekday: 1,
                          timeStartSorter: 0,
                        ),
                        isNewEvent: true,
                      );
                    },
                  );
                },
                child: Container(
                  color: Colors.white.withOpacity(0),
                  child: const Center(
                    child: Text(
                      "Crear Evento",
                      style: TextStyle(
                        color: CupertinoColors.systemBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text(
                              "¿Estas seguro que quieres borrar esta sessión?"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              isDefaultAction: false,
                              child: const Text("Si"),
                              onPressed: () {
                                deleteSession();
                                Navigator.of(context).pop(false);
                              },
                            ),
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: const Text("No"),
                              onPressed: () => Navigator.of(context).pop(false),
                            )
                          ],
                        );
                      });
                },
                child: Container(
                  color: Colors.white.withOpacity(0),
                  child: const Center(
                    child: Text(
                      "Borrar Session",
                      style: TextStyle(
                        color: CupertinoColors.systemRed,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
