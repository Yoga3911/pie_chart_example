import 'dart:math';

import 'package:flutter/material.dart';

class ChartExample extends StatelessWidget {
  const ChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pie Chart Example'),
        ),
        body: const Center(
          child: PieChart(
            size: Size(300, 300),
            dataMap: {
              'A': 30,
              'B': 20,
              'C': 25,
              'D': 25,
            },
            gradientList: [
              [Colors.blue, Colors.black],
              [Colors.green, Colors.lightGreen],
              [Colors.orange, Colors.deepOrange],
              [Colors.red, Colors.pink],
            ],
          ),
        ),
      ),
    );
  }
}

class PieChart extends StatelessWidget {
  final Map<String, double> dataMap;
  final List<List<Color>> gradientList;
  final Size size;

  const PieChart(
      {super.key,
      required this.dataMap,
      required this.gradientList,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: PieChartPainter(dataMap, gradientList),
        child: Center(
          child: Container(
            width: size.width / 2,
            height: size.height / 2,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Center(
              child: Text(
                'Pie Chart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, double> dataMap;
  final List<List<Color>> gradientList;

  PieChartPainter(this.dataMap, this.gradientList);

  @override
  void paint(Canvas canvas, Size size) {
    double total = 0.0;
    dataMap.forEach((key, value) {
      total += value;
    });

    double startRadian = -pi / 2;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    dataMap.forEach((key, value) {
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientList[dataMap.keys.toList().indexOf(key)],
      );
      final paint = Paint()
        ..shader = gradient
            .createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startRadian, (value / total) * 2 * pi, true, paint);
      drawTextOnArc(
          canvas, center, radius, startRadian, (value / total) * 2 * pi, key);
      startRadian += (value / total) * 2 * pi;
    });
  }

  void drawTextOnArc(Canvas canvas, Offset center, double radius,
      double startAngle, double sweepAngle, String text) {
    const textStyle = TextStyle(color: Colors.black, fontSize: 12);
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    final angle = startAngle + sweepAngle / 2;
    final xOffset =
        center.dx + radius * 0.8 * cos(angle) - textPainter.width / 2;
    final yOffset =
        center.dy + radius * 0.8 * sin(angle) - textPainter.height / 2;
    final offset = Offset(xOffset, yOffset);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.dataMap != dataMap ||
        oldDelegate.gradientList != gradientList;
  }
}
