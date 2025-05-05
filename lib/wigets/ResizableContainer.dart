import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grand_chess/controllers/HeightController.dart';

class ResizableContainer extends StatefulWidget {
  final double initSize;
  final double minSize;
  final double maxSize;
  final Widget child;

  const ResizableContainer(
      {super.key,
      required this.initSize,
      required this.minSize,
      required this.maxSize,
      required this.child});
  @override
  State<StatefulWidget> createState() => ResizableContainteinerState();
}

class ResizableContainteinerState extends State<ResizableContainer> {
  late double size;
  bool isHover = false;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    size = widget.initSize;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: widget.child,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: MouseRegion(
            onEnter: (e) {
              setState(() {
                isHover = true;
              });
            },
            onExit: (e) {
              setState(() {
                isHover = false;
              });
            },
            child: Listener(
              onPointerDown: (e) {
                setState(() {
                  isPressed = true;
                });
              },
              onPointerUp: (e) {
                setState(() {
                  isPressed = false;
                });
              },
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    final delta = (details.delta.dx + details.delta.dy) / 2;
                    size = (size + delta).clamp(widget.minSize, widget.maxSize);
                    HeightController.heightNotifier.value = size;
                  });
                },
                child: Transform.translate(
                  offset: Offset(-0.5, 3),
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPressed
                          ? Colors.green[300]
                          : (isHover ? Colors.red[300] : Colors.transparent),
                    ),
                    child: Transform.rotate(
                      angle: -pi / 4,
                      child: Icon(
                        Icons.drag_handle_rounded,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
