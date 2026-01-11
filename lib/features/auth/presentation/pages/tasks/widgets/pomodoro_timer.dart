// ==============================
// ⏱️ POMODORO TIMER WIDGET
// ==============================
// Timer Pomodoro com countdown e círculo de progresso animado
// Similar ao componente PomodoroTimer do React

import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Enum para os modos do Pomodoro
enum PomodoroMode {
  focus,  // Modo foco (25 min)
  break_  // Modo pausa (5 min) - underscore para evitar conflito com keyword
}

/// PomodoroTimer - Timer Pomodoro completo
/// 
/// Em React seria:
/// const [mode, setMode] = useState('focus')
/// const [timeLeft, setTimeLeft] = useState(25 * 60)
/// const [isRunning, setIsRunning] = useState(false)
class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  // ===== CONSTANTES =====
  static const int _focusTime = 25 * 60; // 25 minutos em segundos
  static const int _breakTime = 5 * 60;  // 5 minutos em segundos

  // ===== ESTADO =====
  // Similar a: const [mode, setMode] = useState('focus')
  PomodoroMode _mode = PomodoroMode.focus;
  
  // Similar a: const [timeLeft, setTimeLeft] = useState(25 * 60)
  int _timeLeft = _focusTime;
  
  // Similar a: const [isRunning, setIsRunning] = useState(false)
  bool _isRunning = false;

  // Timer do Dart (não confundir com o widget Timer)
  // Similar a: const intervalRef = useRef<NodeJS.Timeout>()
  Timer? _timer;

  /// initState - Chamado quando o widget é criado
  /// Similar ao useEffect(() => { ... }, []) (sem dependencies)
  @override
  void initState() {
    super.initState();
    // Inicialização se necessário
  }

  /// dispose - Chamado quando o widget é destruído
  /// Similar ao cleanup do useEffect: return () => clearInterval(...)
  /// IMPORTANTE: sempre limpar timers para evitar memory leaks!
  @override
  void dispose() {
    _timer?.cancel(); // Cancela o timer se estiver ativo
    super.dispose();
  }

  /// Inicia ou pausa o timer
  /// Similar a: const toggleTimer = () => setIsRunning(!isRunning)
  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  /// Inicia o countdown
  /// Similar a: intervalRef.current = setInterval(() => {...}, 1000)
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          // Timer terminou!
          _timer?.cancel();
          _isRunning = false;
          _onTimerComplete();
        }
      });
    });
  }

  /// Chamado quando o timer termina
  void _onTimerComplete() {
    // Mostra dialog de conclusão
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _mode == PomodoroMode.focus
              ? '🎉 Tempo de foco concluído!'
              : '✨ Pausa concluída!',
        ),
        content: Text(
          _mode == PomodoroMode.focus
              ? 'Hora de fazer uma pausa! Seu cérebro merece descanso.'
              : 'Pausa terminada! Pronto para focar novamente?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Pode automaticamente trocar o modo aqui se quiser
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Reseta o timer para o tempo inicial do modo atual
  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      _timeLeft = _mode == PomodoroMode.focus ? _focusTime : _breakTime;
    });
  }

  /// Troca entre modo foco e pausa
  void _switchMode(PomodoroMode newMode) {
    setState(() {
      _mode = newMode;
      _isRunning = false;
      _timer?.cancel();
      _timeLeft = newMode == PomodoroMode.focus ? _focusTime : _breakTime;
    });
  }

  /// Formata segundos para MM:SS
  /// Similar a: const formatTime = (seconds) => { ... }
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60; // ~/ é divisão inteira
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Calcula o progresso (0.0 a 1.0)
  double get _progress {
    final totalTime = _mode == PomodoroMode.focus ? _focusTime : _breakTime;
    return (totalTime - _timeLeft) / totalTime;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      // Gradiente de fundo
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.blue.shade200,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            _buildHeader(),
            
            const SizedBox(height: 32),
            
            // ===== TIMER VISUAL (CÍRCULO) =====
            Center(
              child: _buildTimerCircle(),
            ),
            
            const SizedBox(height: 32),
            
            // ===== CONTROLES =====
            _buildControls(),
            
            const SizedBox(height: 16),
            
            // ===== INFO =====
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  /// Constrói o header com título e switch de modo
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Título
        Row(
          children: [
            Icon(Icons.timer, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            const Text(
              'Timer Pomodoro',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        
        // Switch de modo
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _buildModeButton('Foco', PomodoroMode.focus),
              const SizedBox(width: 4),
              _buildModeButton('Pausa', PomodoroMode.break_),
            ],
          ),
        ),
      ],
    );
  }

  /// Botão para trocar modo
  Widget _buildModeButton(String label, PomodoroMode mode) {
    final isSelected = _mode == mode;
    final color = mode == PomodoroMode.focus 
        ? Colors.blue.shade600 
        : Colors.green.shade600;
    
    return InkWell(
      onTap: () => _switchMode(mode),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  /// Constrói o círculo de progresso com o tempo
  Widget _buildTimerCircle() {
    final color = _mode == PomodoroMode.focus 
        ? Colors.blue.shade600 
        : Colors.green.shade600;
    
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de progresso
          CustomPaint(
            size: const Size(200, 200),
            painter: CircleProgressPainter(
              progress: _progress,
              color: color,
            ),
          ),
          
          // Texto do tempo
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(_timeLeft),
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _mode == PomodoroMode.focus ? 'Tempo de Foco' : 'Tempo de Pausa',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Constrói os controles (reset, play/pause)
  Widget _buildControls() {
    final color = _mode == PomodoroMode.focus 
        ? Colors.blue.shade600 
        : Colors.green.shade600;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botão Reset
        IconButton.filled(
          onPressed: _resetTimer,
          icon: const Icon(Icons.refresh),
          iconSize: 24,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.all(16),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Botão Play/Pause (maior)
        ElevatedButton.icon(
          onPressed: _toggleTimer,
          icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 24),
          label: Text(_isRunning ? 'Pausar' : 'Iniciar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Constrói a informação sobre o modo atual
  Widget _buildInfo() {
    return Center(
      child: Text(
        _mode == PomodoroMode.focus
            ? '25 minutos de foco intenso, depois 5 minutos de pausa'
            : '5 minutos de descanso para recarregar as energias',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

// ==============================
// 🎨 CUSTOM PAINTER - CÍRCULO DE PROGRESSO
// ==============================

/// CustomPainter que desenha o círculo de progresso
/// Similar ao <svg> do React / Canvas do HTML5
class CircleProgressPainter extends CustomPainter {
  final double progress; // 0.0 a 1.0
  final Color color;

  CircleProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // ===== CÍRCULO DE FUNDO (cinza) =====
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    
    canvas.drawCircle(center, radius, backgroundPaint);

    // ===== CÍRCULO DE PROGRESSO (colorido) =====
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round; // Pontas arredondadas

    // Desenha o arco (de -90° até o progresso)
    // -90° (math.pi / 2) começa do topo
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    // Repinta se o progresso ou cor mudaram
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

// ==============================
// 📝 CONCEITOS FLUTTER IMPORTANTES
// ==============================

/*
1. Timer.periodic - Executar repetidamente:
   React: const interval = setInterval(() => {...}, 1000)
   Flutter: Timer.periodic(Duration(seconds: 1), (timer) => {...})
   - Retorna Timer? que pode ser cancelado
   - SEMPRE cancelar no dispose()!

2. dispose() - Cleanup:
   React: useEffect(() => { return () => clearInterval(interval) }, [])
   Flutter: @override void dispose() { _timer?.cancel(); }
   - CRÍTICO para evitar memory leaks
   - Limpar timers, controllers, listeners

3. CustomPaint - Desenho customizado:
   Similar a Canvas API do HTML5 ou SVG
   - CustomPainter: classe que define o que desenhar
   - paint(): método onde desenha usando Canvas
   - shouldRepaint(): otimização (quando redesenhar)

4. Canvas Drawing:
   - canvas.drawCircle(): desenha círculo
   - canvas.drawArc(): desenha arco (parte de círculo)
   - Paint(): define cor, espessura, estilo

5. Divisão Inteira:
   JavaScript: Math.floor(seconds / 60)
   Dart: seconds ~/ 60
   - ~/ é operador de divisão inteira

6. Getter Computed:
   double get _progress { ... }
   - Calcula valor derivado automaticamente
   - Recalculado quando dependências mudam

7. Enum:
   Similar a TypeScript/JavaScript
   - Define conjunto fixo de valores
   - Type-safe (compilador verifica)

8. showDialog() - Notificação:
   Mostra popup quando timer termina
   Similar a: alert() ou notification API
*/
