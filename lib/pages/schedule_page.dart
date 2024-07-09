import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oceanic_teachers/models/session.dart';
import 'package:oceanic_teachers/models/timeblock.dart';
import 'package:oceanic_teachers/pages/edit/timeblock_page.dart';
import 'package:oceanic_teachers/utils/colors.dart';
import 'package:oceanic_teachers/widgets/hour_divider.dart';
import 'package:oceanic_teachers/widgets/schedule_class_space.dart';
import 'package:oceanic_teachers/widgets/schedule_empty_space.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleViewPage extends StatefulWidget {
  const ScheduleViewPage({super.key});

  @override
  State<ScheduleViewPage> createState() => _ScheduleViewPageState();
}

class _ScheduleViewPageState extends State<ScheduleViewPage> {
  final ScrollController scrollController = ScrollController(
      initialScrollOffset:
          DateTime.now().hour * 60.0 + DateTime.now().minute.toDouble() - 120);

  @override
  Widget build(BuildContext context) {
    double maxWidth = (MediaQuery.of(context).size.width - 20) / 6;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('timeblocks')
          .where('teacher', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('timeStartSorter')
          .snapshots(),
      builder: (context, snapshot) {
        List<List<TimeBlock>> timeblocksDays = [[], [], [], [], [], []];

        List<Widget> schedule = [];

        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          for (final timeblocDocs in snapshot.data!.docs) {
            TimeBlock tb = TimeBlock.fromJson(timeblocDocs.data());
            timeblocksDays[tb.weekday - 1].add(tb);
          }
        }

        for (int i = 0; i < 6; i++) {
          List<Widget> scheduleDay = [];

          if (timeblocksDays[i].isNotEmpty) {
            for (int j = 0; j < timeblocksDays[i].length; j++) {
              if (j == 0 && timeblocksDays[i][j].timeStart != '00:00') {
                scheduleDay.add(
                  ScheduleEmptySpace(
                    height: calculateTimeDelta(
                        '00:00', timeblocksDays[i][j].timeStart),
                    width: maxWidth,
                  ),
                );
              }
              scheduleDay.add(
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('sessions')
                      .doc(timeblocksDays[i][j].session)
                      .get(),
                  builder: (context, snapshot) {
                    Color color = Colors.white;
                    String cname = 'Classe';

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Skeletonizer(
                        enabled: true,
                        child: ScheduleClassSpace(
                          height: calculateTimeDelta(
                            timeblocksDays[i][j].timeStart,
                            timeblocksDays[i][j].timeEnd,
                          ),
                          width: maxWidth,
                          color: color.withOpacity(0.1),
                          timeStart: timeblocksDays[i][j].timeStart,
                          timeEnd: timeblocksDays[i][j].timeEnd,
                          className: 'PFCS013',
                          room: 'V202',
                          onTap: () {},
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      Session session = Session.fromJson(
                          snapshot.data!.data() as Map<String, dynamic>);

                      color = defaultThemeColors[session.color];
                      cname = session.code;
                    }

                    return ScheduleClassSpace(
                      height: calculateTimeDelta(timeblocksDays[i][j].timeStart,
                          timeblocksDays[i][j].timeEnd),
                      width: maxWidth,
                      color: color,
                      timeStart: timeblocksDays[i][j].timeStart,
                      timeEnd: timeblocksDays[i][j].timeEnd,
                      className: cname,
                      room: timeblocksDays[i][j].room,
                      onTap: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return EditTimeBlockPage(
                              timeBlock: timeblocksDays[i][j],
                              isNewTimeBlock: false,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }

            if (timeblocksDays[i].last.timeEnd != '24:00') {
              scheduleDay.add(
                ScheduleEmptySpace(
                  height: calculateTimeDelta(
                      timeblocksDays[i].last.timeEnd, '24:00'),
                  width: maxWidth,
                ),
              );
            }
          } else {
            scheduleDay.add(
              ScheduleEmptySpace(
                height: calculateTimeDelta('00:00', '24:00'),
                width: maxWidth,
              ),
            );
          }

          if (i == DateTime.now().weekday - 1) {
            schedule.add(
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: maxWidth,
                      height: 1440,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: scheduleDay,
                  ),
                ],
              ),
            );
          } else {
            schedule.add(
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: scheduleDay,
              ),
            );
          }
        }

        return ListView(
          controller: scrollController,
          children: [
            Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '00',
                          hideTimeTip: hideTimeTip(0),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '01',
                          hideTimeTip: hideTimeTip(1),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '02',
                          hideTimeTip: hideTimeTip(2),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '03',
                          hideTimeTip: hideTimeTip(3),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '04',
                          hideTimeTip: hideTimeTip(4),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '05',
                          hideTimeTip: hideTimeTip(5),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '06',
                          hideTimeTip: hideTimeTip(6),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '07',
                          hideTimeTip: hideTimeTip(7),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '08',
                          hideTimeTip: hideTimeTip(8),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '09',
                          hideTimeTip: hideTimeTip(9),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '10',
                          hideTimeTip: hideTimeTip(10),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '11',
                          hideTimeTip: hideTimeTip(11),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '12',
                          hideTimeTip: hideTimeTip(12),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '13',
                          hideTimeTip: hideTimeTip(13),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '14',
                          hideTimeTip: hideTimeTip(14),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '15',
                          hideTimeTip: hideTimeTip(15),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '16',
                          hideTimeTip: hideTimeTip(16),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '17',
                          hideTimeTip: hideTimeTip(17),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '18',
                          hideTimeTip: hideTimeTip(18),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '19',
                          hideTimeTip: hideTimeTip(19),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '20',
                          hideTimeTip: hideTimeTip(20),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '21',
                          hideTimeTip: hideTimeTip(21),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '22',
                          hideTimeTip: hideTimeTip(22),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '23',
                          hideTimeTip: hideTimeTip(23),
                        ),
                        HourDivider(
                          width: 20 + (maxWidth * 6),
                          hourStr: '00',
                          hideTimeTip: hideTimeTip(00),
                        ),
                      ]),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: schedule,
                  ),
                ),
                StreamBuilder<Object>(
                    stream: Stream.periodic(
                      const Duration(seconds: 1),
                    ).asyncMap((event) => Future.value(true)),
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HourDivider(
                                width: 20 + (maxWidth * 6),
                                hourStr:
                                    '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                                highlight: true,
                                hightOffset: DateTime.now()
                                            .add(const Duration(seconds: 1))
                                            .hour *
                                        60 +
                                    DateTime.now()
                                        .add(const Duration(seconds: 1))
                                        .minute
                                        .toDouble(),
                              ),
                            ]),
                      );
                    }),
              ],
            ),
          ],
        );
      },
    );
  }
}

bool hideTimeTip(int hr) {
  DateTime now = DateTime.now();

  if (now.hour == hr) {
    if (now.minute <= 15) {
      return true;
    }
  }
  if (now.hour + 1 == hr) {
    if (now.minute >= 50) {
      return true;
    }
  }

  return false;
}

double calculateTimeDelta(String start, String end) {
  int startMin =
      int.parse(start.split(":")[1]) + (int.parse(start.split(":")[0]) * 60);

  int endMin =
      int.parse(end.split(":")[1]) + (int.parse(end.split(":")[0]) * 60);

  return (endMin - startMin).toDouble();
}
