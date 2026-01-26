import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/pomodoro_timer_styles.dart';

enum PomodoroMode { focus, break_ }

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  static const int _focusTime = 25 * 60;
  static const int _breakTime = 5 * 60;

  PomodoroMode _mode = PomodoroMode.focus;
  int _timeLeft = _focusTime;
  bool _isRunning = false;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _totalTime => _mode == PomodoroMode.focus ? _focusTime : _breakTime;

  double get _progress => (_totalTime - _timeLeft) / _totalTime;

  void _toggleTimer() {
    setState(() => _isRunning = !_isRunning);

    if (_isRunning) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _onTimerComplete();
        }
      });
    });
  }

  void _onTimerComplete() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            _mode == PomodoroMode.focus
                ? '🎉 Tempo de foco concluído!'
                : '✨ Pausa concluída!',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            _mode == PomodoroMode.focus
                ? 'Hora de fazer uma pausa!'
                : 'Pronto para focar novamente?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.80),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _timeLeft = _totalTime;
    });
  }

  void _switchMode(PomodoroMode newMode) {
    _timer?.cancel();
    setState(() {
      _mode = newMode;
      _isRunning = false;
      _timeLeft = _totalTime;
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final styles = PomodoroTimerStyles(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: PomodoroTimerStyles.maxWidth),
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PomodoroTimerStyles.cardRadius),
            side: BorderSide(
              color: styles.borderColor,
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: styles.gradientColors,
              ),
            ),
            padding: const EdgeInsets.all(PomodoroTimerStyles.padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(styles),
                const SizedBox(height: 18),
                _buildTimerCircle(styles),
                const SizedBox(height: 18),
                _buildControls(styles),
                const SizedBox(height: 14),
                _buildInfo(styles),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header fixo: "Timer" / "Pomodoro" à esquerda, toggle sempre ao lado.
  Widget _buildHeader(PomodoroTimerStyles styles) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: PomodoroTimerStyles.headerIconTop),
                child: Icon(
                  Icons.timer_outlined,
                  color: styles.primary,
                  size: PomodoroTimerStyles.headerIconSize,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Timer', style: styles.headerTitle),
                  const SizedBox(height: 2),
                  Text('Pomodoro', style: styles.headerTitle),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(top: PomodoroTimerStyles.headerRightTop),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: _SegmentedMode(
              mode: _mode,
              onChanged: _switchMode,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerCircle(PomodoroTimerStyles styles) {
    final label = _mode == PomodoroMode.focus ? 'Tempo de Foco' : 'Tempo de Pausa';

    return SizedBox(
      width: PomodoroTimerStyles.circleSize,
      height: PomodoroTimerStyles.circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(
              PomodoroTimerStyles.circleSize,
              PomodoroTimerStyles.circleSize,
            ),
            painter: CircleProgressPainter(
              progress: _progress,
              color: styles.primary,
              ringBg: styles.ringBg,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_formatTime(_timeLeft), style: styles.timeText),
              const SizedBox(height: 6),
              Text(label, style: styles.subLabel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls(PomodoroTimerStyles styles) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: _resetTimer,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: PomodoroTimerStyles.resetSize,
            height: PomodoroTimerStyles.resetSize,
            decoration: BoxDecoration(
              color: styles.chipBg,
              shape: BoxShape.circle,
              border: Border.all(color: styles.outline),
            ),
            child: Icon(
              Icons.refresh,
              color: styles.iconMuted,
              size: PomodoroTimerStyles.resetIconSize,
            ),
          ),
        ),
        const SizedBox(width: 14),
        SizedBox(
          height: PomodoroTimerStyles.actionHeight,
          child: ElevatedButton.icon(
            onPressed: _toggleTimer,
            icon: Icon(
              _isRunning ? Icons.pause : Icons.play_arrow,
              size: PomodoroTimerStyles.actionIconSize,
            ),
            label: Text(_isRunning ? 'Pausar' : 'Iniciar'),
            style: styles.actionButtonStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(PomodoroTimerStyles styles) {
    return Text(
      _mode == PomodoroMode.focus
          ? '25 minutos de foco intenso, depois 5 minutos\nde pausa'
          : '5 minutos de descanso para recarregar\nas energias',
      textAlign: TextAlign.center,
      style: styles.info,
    );
  }
}

class _SegmentedMode extends StatelessWidget {
  final PomodoroMode mode;
  final ValueChanged<PomodoroMode> onChanged;

  const _SegmentedMode({
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final styles = PomodoroTimerStyles(context);

    Widget item(String label, PomodoroMode value) {
      final selected = mode == value;

      return InkWell(
        onTap: () => onChanged(value),
        borderRadius: PomodoroTimerStyles.segItemRadius(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          constraints: PomodoroTimerStyles.segConstraints,
          padding: PomodoroTimerStyles.segItemPadding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? styles.primary : Colors.transparent,
            borderRadius: PomodoroTimerStyles.segItemRadius(),
          ),
          child: Text(label, style: styles.segText(selected: selected)),
        ),
      );
    }

    return Container(
      padding: PomodoroTimerStyles.segOuterPadding,
      decoration: BoxDecoration(
        color: styles.chipBg,
        borderRadius: PomodoroTimerStyles.segRadius(),
        border: Border.all(color: styles.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          item('Foco', PomodoroMode.focus),
          item('Pausa', PomodoroMode.break_),
        ],
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color ringBg;

  const CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.ringBg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;

    final bg = Paint()
      ..color = ringBg
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, bg);

    final fg = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.ringBg != ringBg;
  }
}
