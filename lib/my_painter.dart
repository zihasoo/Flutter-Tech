
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Node {
  final String text;
  final double x, y, radius;

  const Node(this.text, this.x, this.y, this.radius);
}

class MyPainter extends CustomPainter {
  var _width = 0.0;
  var _height = 0.0;

  List<Node> nodeList;

  MyPainter(this.nodeList);

  void _drawBackground(Canvas canvas) {
    var background = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white70
      ..isAntiAlias = true;
    var rect = Rect.fromLTWH(0, 0, _width, _height);
    canvas.drawRect(rect, background);
  }

  void _drawGrid(Canvas canvas) {
    const rows = 10;
    const cols = 10;

    var linePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black38
      ..isAntiAlias = true;

    final gridWidth = _width / cols;
    final gridHeight = _height / rows;

    for (int row = 0; row < rows; row++) {
      final y = row * gridHeight;
      final p1 = Offset(0, y);
      final p2 = Offset(_width, y);

      canvas.drawLine(p1, p2, linePaint);
    }

    for (int col = 0; col < cols; col++) {
      final x = col * gridWidth;
      final p1 = Offset(x, 0);
      final p2 = Offset(x, _height);

      canvas.drawLine(p1, p2, linePaint);
    }
  }

  void _drawText(Canvas canvas, centerX, centerY, text, style) {
    final textSpan = TextSpan(
      text: text,
      style: style,
    );

    final textPainter = TextPainter()
      ..text = textSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    final xCenter = (centerX - textPainter.width / 2);
    final yCenter = (centerY - textPainter.height / 2);
    final offset = Offset(xCenter, yCenter);

    textPainter.paint(canvas, offset);
  }

  void _drawNodes(Canvas canvas) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.amber
      ..isAntiAlias = true;

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
    );

    const radius = 30.0;
    for (var node in nodeList) {
      final offset = Offset(node.x, node.y);
      canvas.drawCircle(offset, node.radius, paint);
      _drawText(
          canvas, node.x, node.y, node.text, textStyle);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _width = size.width;
    _height = size.height;

    _drawBackground(canvas);
    _drawGrid(canvas);
    _drawNodes(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
