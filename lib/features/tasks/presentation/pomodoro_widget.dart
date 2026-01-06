
import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroWidget extends StatefulWidget {
  const PomodoroWidget({super.key});

  @override
  State<PomodoroWidget> createState() => _PomodoroWidgetState();
}

class _PomodoroWidgetState extends State<PomodoroWidget> {
  int seconds = 1500;
  Timer? timer;

  void start() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => seconds--);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Foco: ${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}'),
        ElevatedButton(onPressed: start, child: const Text('Iniciar Foco')),
      ],
    );
  }
}
