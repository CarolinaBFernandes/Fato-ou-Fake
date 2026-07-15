import 'dart:async';

class CronometroService {
  Timer? _timer;

  final int tempoMaximo;
  int tempoRestante;

  final Function(int) onTick;
  final Function() onTimeout;

  CronometroService({
    required this.tempoMaximo,
    required this.onTick,
    required this.onTimeout,
  }) : tempoRestante = tempoMaximo;

  void iniciar() {
    parar();

    tempoRestante = tempoMaximo;

    onTick(tempoRestante);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      tempoRestante--;

      onTick(tempoRestante);

      if (tempoRestante <= 0) {
        parar();
        onTimeout();
      }
    });
  }

  void parar() {
    _timer?.cancel();
  }

  void dispose() {
    parar();
  }
}