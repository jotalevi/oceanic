import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oceanic_teachers/models/timeblock.dart';
import 'package:oceanic_teachers/utils/weekday.dart';

class EditTimeBlockPage extends StatefulWidget {
  final bool isNewTimeBlock;
  final TimeBlock timeBlock;
  const EditTimeBlockPage(
      {super.key, required this.timeBlock, this.isNewTimeBlock = false});

  @override
  State<EditTimeBlockPage> createState() => _EditTimeBlockPageState();
}

class _EditTimeBlockPageState extends State<EditTimeBlockPage> {
  late TextEditingController rommController;
  late DateTime timeStart;
  late DateTime timeEnd;
  late int weekday;

  @override
  initState() {
    super.initState();

    weekday = widget.timeBlock.weekday;
    rommController = TextEditingController(text: widget.timeBlock.room);

    if (widget.isNewTimeBlock) {
      timeStart = DateTime.now();
      timeEnd = timeStart.add(const Duration(minutes: 75));
    } else {
      timeStart =
          DateTime.parse('2021-01-01 ${widget.timeBlock.timeStart}:00.000');
      timeEnd = DateTime.parse('2021-01-01 ${widget.timeBlock.timeEnd}:00.000');
    }
  }

  bool canSave() {
    return true;
  }

  save() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    TimeBlock t = TimeBlock(
      id: widget.timeBlock.id,
      teacher: FirebaseAuth.instance.currentUser!.uid,
      session: widget.timeBlock.session,
      room: rommController.text,
      timeStart:
          '${timeStart.hour.toString().padLeft(2, '0')}:${timeStart.minute.toString().padLeft(2, '0')}',
      timeEnd:
          '${timeEnd.hour.toString().padLeft(2, '0')}:${timeEnd.minute.toString().padLeft(2, '0')}',
      timeStartSorter: int.parse(timeStart.hour.toString().padLeft(2, '0') +
          timeStart.minute.toString().padLeft(2, '0')),
      weekday: weekday,
    );

    if (widget.isNewTimeBlock) {
      firestore.collection('timeblocks').doc(t.id).set(t.toJson());
    } else {
      firestore.collection('timeblocks').doc(t.id).update(t.toJson());
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
            Text(
              widget.isNewTimeBlock ? 'Nueva Classe' : 'Editar Classe',
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
              placeholder: 'Sala:',
              controller: rommController,
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
                setState(() {
                  rommController.text = _;
                });
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
                        initialItem: weekday - 1,
                      ),
                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          weekday = selectedItem + 1;
                        });
                      },
                      children: List<Widget>.generate(
                        6,
                        (int index) {
                          return Center(
                            child: Text(
                              weekDayStrFromInt(index + 1),
                              style: const TextStyle(
                                color: Colors.white,
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
                          "Dia:",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          weekDayStrFromInt(weekday),
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
                    CupertinoDatePicker(
                      onDateTimeChanged: (_) {
                        setState(() {
                          timeStart = _;
                        });
                      },
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      initialDateTime: timeStart,
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
                          "Hora de Inicio:",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          '${timeStart.hour.toString().padLeft(2, '0')}:${timeStart.minute.toString().padLeft(2, '0')}',
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
                    CupertinoDatePicker(
                      onDateTimeChanged: (_) {
                        setState(() {
                          timeEnd = _;
                        });
                      },
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      initialDateTime: timeEnd,
                      minimumDate: timeStart.add(const Duration(minutes: 15)),
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
                          "Hora de Termino:",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          '${timeEnd.hour.toString().padLeft(2, '0')}:${timeEnd.minute.toString().padLeft(2, '0')}',
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
                      canSave() ? save() : null;
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      color: canSave()
                          ? Colors.blue
                          : Colors.white.withOpacity(0.2),
                      child: Center(
                        child: Text(
                          "Guardar",
                          style: TextStyle(
                            color: CupertinoColors.white
                                .withOpacity(canSave() ? 1 : 0.5),
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
  }
}
