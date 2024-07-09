import 'package:flutter/material.dart';

class ScheduleEmptySpace extends StatelessWidget {
  final double height;
  final double width;
  const ScheduleEmptySpace({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: width,
      height: height,
    );
  }
}
