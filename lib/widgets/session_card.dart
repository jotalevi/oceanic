import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oceanic_teachers/models/session.dart';
import 'package:oceanic_teachers/pages/edit/session_page.dart';
import 'package:oceanic_teachers/utils/colors.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  const SessionCard({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
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
            color: defaultThemeColors[session.color].withOpacity(0.1),
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
                        session.code,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.5),
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
