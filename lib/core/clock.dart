import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Este es el widget reutilizable. NO tiene Scaffold.
class MinimalClockWidget extends StatefulWidget {
  const MinimalClockWidget({super.key});

  @override
  State<MinimalClockWidget> createState() => _MinimalClockWidgetState();
}

class _MinimalClockWidgetState extends State<MinimalClockWidget> {
  DateTime _now = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Actualiza cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Puedes mover estos colores a tu archivo de diseño si prefieres
    const Color clockColor = Color(0xFF2C3E50);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Centrado verticalmente
      children: [
        // El dibujo del reloj
        SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: ClockPainter(time: _now, color: clockColor),
          ),
        ),
        const SizedBox(height: 30),
        // Hora
        Text(
          '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(
            color: clockColor,
            fontSize: 60,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
          ),
        ),
        const SizedBox(height: 10),
        // Fecha
        Text(
          '${_now.day.toString().padLeft(2, '0')}/${_now.month.toString().padLeft(2, '0')}/${_now.year}',
          style: const TextStyle(
            color: clockColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Lógica de pintura (Matemáticas del reloj)
class ClockPainter extends CustomPainter {
  final DateTime time;
  final Color color;

  ClockPainter({required this.time, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // Círculo
    canvas.drawCircle(center, radius, paint);

    // Minutero
    final double minuteAngle = (time.minute * 6) * (pi / 180) - (pi / 2);
    final double minuteHandLength = radius * 0.7;
    canvas.drawLine(
      center,
      Offset(
        center.dx + minuteHandLength * cos(minuteAngle),
        center.dy + minuteHandLength * sin(minuteAngle),
      ),
      paint,
    );

    // Horario
    final double hourAngle =
        ((time.hour % 12 + time.minute / 60) * 30) * (pi / 180) - (pi / 2);
    final double hourHandLength = radius * 0.45;
    canvas.drawLine(
      center,
      Offset(
        center.dx + hourHandLength * cos(hourAngle),
        center.dy + hourHandLength * sin(hourAngle),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    return oldDelegate.time.minute != time.minute ||
        oldDelegate.time.hour != time.hour;
  }
}
