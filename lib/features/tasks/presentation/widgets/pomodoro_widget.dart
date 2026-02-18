import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindease_focus/features/tasks/presentation/widgets/pomodoro_widget_styles.dart';


class PomodoroWidget extends StatefulWidget {
  const PomodoroWidget({super.key});

  @override
  State<PomodoroWidget> createState() => _PomodoroWidgetState();
}

class _PomodoroWidgetState extends State<PomodoroWidget> {
  int seconds = PomodoroWidgetStyles.initialSeconds;
  Timer? timer;

  void start() {
    timer = Timer.periodic(PomodoroWidgetStyles.tick, (_) {
      setState(() => seconds--);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(PomodoroWidgetStyles.timeLabel(seconds)),
        ElevatedButton(
          onPressed: start,
          child: const Text(PomodoroWidgetStyles.buttonLabel),
        ),
      ],
    );
  }
}
