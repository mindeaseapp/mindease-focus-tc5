import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/pomodoro_timer_styles.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/pomodoro_controller.dart';

class PomodoroTimer extends StatefulWidget {
  final bool highContrast;
  final bool hideDistractions;

  const PomodoroTimer({
    super.key,
    this.highContrast = false,
    this.hideDistractions = false,
  });

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  bool _dialogShown = false;
  int _lastTimeLeft = -1;

  void _onTimerComplete(BuildContext context, PomodoroMode mode) {
    if (_dialogShown) return;
    _dialogShown = true;
    

    // Actually consistent with build method, we can instantiate it here.

    showDialog(
      context: context,
      builder: (context) {
        // Re-instantiate styles with dialog context to be safe with theme access, 
        // though typically outer context is fine for theme.
        // Let's use the styles instance created above if possible, but context is different in builder.
        // Actually, let's just use PomodoroTimerStyles(context) inside the builder to be safe.
        final dialogStyles = PomodoroTimerStyles(context);

        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: PomodoroTimerStyles.dialogShape,
          title: Text(
            mode == PomodoroMode.focus
                ? '🎉 Tempo de foco concluído!'
                : '✨ Pausa concluída!',
            style: dialogStyles.dialogTitle,
          ),
          content: Text(
            mode == PomodoroMode.focus
                ? 'Hora de fazer uma pausa!'
                : 'Pronto para focar novamente?',
            style: dialogStyles.dialogContent,
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

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PomodoroController>();
    final styles = PomodoroTimerStyles(context);

    if (controller.timeLeft != _lastTimeLeft) {
      _lastTimeLeft = controller.timeLeft;
      if (controller.timeLeft > 0) {
        _dialogShown = false;
      }
    }

    if (controller.timeLeft == 0 && !controller.isRunning) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.timeLeft == 0) {
          _onTimerComplete(context, controller.mode);
        }
      });
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: PomodoroTimerStyles.maxWidth),
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PomodoroTimerStyles.cardRadius),
            side: BorderSide(
              color: styles.borderColor(highContrast: widget.highContrast),
              width: widget.highContrast ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: styles.gradientColors(highContrast: widget.highContrast),
              ),
            ),
            padding: const EdgeInsets.all(PomodoroTimerStyles.padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(styles, controller, widget.highContrast),
                const SizedBox(height: 18),
                _buildTimerCircle(styles, controller, widget.highContrast),
                const SizedBox(height: 18),
                _buildControls(styles, controller, widget.highContrast),
                if (!widget.hideDistractions) ...[
                  const SizedBox(height: 14),
                  _buildInfo(styles, controller, widget.highContrast),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(PomodoroTimerStyles styles, PomodoroController controller, bool highContrast) {
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
              mode: controller.mode,
              onChanged: controller.switchMode,
              highContrast: highContrast,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerCircle(PomodoroTimerStyles styles, PomodoroController controller, bool highContrast) {
    final label = controller.mode == PomodoroMode.focus ? 'Tempo de Foco' : 'Tempo de Pausa';

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
              progress: controller.progress,
              color: styles.primary,
              ringBg: styles.ringBg(highContrast: highContrast),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.formattedTime, style: styles.timeText),
              const SizedBox(height: 6),
              Text(label, style: styles.subLabel(highContrast: highContrast)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls(PomodoroTimerStyles styles, PomodoroController controller, bool highContrast) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: controller.resetTimer,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: PomodoroTimerStyles.resetSize,
            height: PomodoroTimerStyles.resetSize,
            decoration: BoxDecoration(
              color: styles.chipBg(highContrast: highContrast),
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
            onPressed: controller.toggleTimer,
            icon: Icon(
              controller.isRunning ? Icons.pause : Icons.play_arrow,
              size: PomodoroTimerStyles.actionIconSize,
            ),
            label: Text(controller.isRunning ? 'Pausar' : 'Iniciar'),
            style: styles.actionButtonStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(PomodoroTimerStyles styles, PomodoroController controller, bool highContrast) {
    return Text(
      controller.mode == PomodoroMode.focus
          ? '25 minutos de foco intenso, depois 5 minutos\nde pausa'
          : '5 minutos de descanso para recarregar\nas energias',
      textAlign: TextAlign.center,
      style: styles.info(highContrast: highContrast),
    );
  }
}

class _SegmentedMode extends StatelessWidget {
  final PomodoroMode mode;
  final ValueChanged<PomodoroMode> onChanged;
  final bool highContrast;

  const _SegmentedMode({
    required this.mode,
    required this.onChanged,
    required this.highContrast,
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
        color: styles.chipBg(highContrast: highContrast),
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
