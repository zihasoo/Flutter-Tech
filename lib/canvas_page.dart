import 'package:flutter/material.dart';
import 'package:flutter_tech/my_painter.dart';

class CanvasPage extends StatefulWidget {
  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  List<Node> nodeList = [
    Node("Node\n1", 150.0, 180.0, 30),
    Node("Node\n2", 220.0, 40.0, 30),
    Node("Node\n3", 380.0, 240.0, 30),
    Node("Node\n4", 240.0, 390.0, 30),
    Node("Node\n5", 80.0, 450.0, 30)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onHorizontalDragUpdate: (detail) {

      },
      child: CustomPaint(
        child: Container(),
        painter: MyPainter(nodeList),
      ),
    ));
  }
}
