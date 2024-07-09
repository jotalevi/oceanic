import 'package:flutter/cupertino.dart';

class FancyContainer extends StatefulWidget {
  final Widget? child;
  final Duration cycle;
  final List<Color> colors;

  const FancyContainer({
    super.key,
    required this.child,
    required this.cycle,
    required this.colors,
  });

  @override
  State<FancyContainer> createState() => _FancyContainer();
}

class _FancyContainer extends State<FancyContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.cycle,
      reverseDuration: widget.cycle,
      animationBehavior: AnimationBehavior.preserve,
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.repeated,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: SlideGradient(
                controller.value,
                MediaQuery.of(context).size.height *
                    (MediaQuery.of(context).size.height /
                        MediaQuery.of(context).size.width),
              ),
              colors: widget.colors,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class SlideGradient implements GradientTransform {
  final double value;
  final double offset;
  const SlideGradient(this.value, this.offset);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final dist = value * (bounds.width + offset);
    return Matrix4.identity()..translate(-dist);
  }
}
