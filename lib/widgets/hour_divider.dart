import 'package:flutter/material.dart';

class HourDivider extends StatelessWidget {
  final double width;
  final String hourStr;
  final bool highlight;
  final double hightOffset;
  final bool hideTimeTip;
  const HourDivider({
    super.key,
    required this.width,
    required this.hourStr,
    this.highlight = false,
    this.hightOffset = 0,
    this.hideTimeTip = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: hightOffset),
      child: Container(
          height: highlight ? 20 : 60,
          width: width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(highlight ? 1 : 0.2),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    hideTimeTip ? '' : hourStr,
                    style: TextStyle(
                      color: Colors.white.withOpacity(highlight ? 1 : 0.5),
                      fontSize: 12,
                      fontWeight:
                          highlight ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
