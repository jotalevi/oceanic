import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oceanic_teachers/models/session.dart';
import 'package:oceanic_teachers/models/timeblock.dart';
import 'package:oceanic_teachers/pages/edit/session_page.dart';
import 'package:oceanic_teachers/utils/colors.dart';

class TimeBlockCard extends StatelessWidget {
  final TimeBlock timeBlock;
  final Session session;
  const TimeBlockCard({
    super.key,
    required this.timeBlock,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int minuteStart = int.parse(timeBlock.timeStart.split(':')[0]) * 60 +
        int.parse(timeBlock.timeStart.split(':')[0]);
    int minuteEnd = int.parse(timeBlock.timeEnd.split(':')[0]) * 60 +
        int.parse(timeBlock.timeEnd.split(':')[0]);
    int minuteNow = now.hour * 60 + now.minute;

    bool isNow = minuteNow >= minuteStart && minuteNow <= minuteEnd;

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: GestureDetector(
        onTap: () {
          showCupertinoModalBottomSheet(
            context: context,
            builder: (context) {
              return EditSessionPage(session: session);
            },
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: isNow
                  ? defaultThemeColors[session.color].withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isNow
                    ? CupertinoColors.systemYellow.withOpacity(0.5)
                    : Colors.white.withOpacity(0),
              ),
            ),
            height: 120,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: defaultThemeColors[session.color],
                  width: 10,
                  height: 120,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              timeBlock.timeStart,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              timeBlock.timeEnd,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          right: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              session.name.length >= 24
                                  ? session.name.substring(0, 24)
                                  : session.name,
                              style: const TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              timeBlock.room,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              session.code,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
