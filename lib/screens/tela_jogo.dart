// Arquivo: lib/screens/tela_jogo.dart

import 'package:flutter/material.dart';
import '../models/pergunta.dart';
import '../data/perguntas.dart';
import '../services/cronometro_service.dart';
import 'tela_resultado.dart';

class TelaJogo extends StatefulWidget {
  const TelaJogo({super.key});

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  int indice = 0;
  int pontuacao = 0;

  late List<Pergunta> perguntas;
  late CronometroService cronometro;

  static const int tempoMaximo = 20;
  int tempoRestante = tempoMaximo;

  bool respondeu = false;

  @override
  void initState() {
    super.initState();

    perguntas = List<Pergunta>.from(bancoPerguntas);
    perguntas.shuffle();

    if (perguntas.length > 10) {
      perguntas = perguntas.take(10).toList();
    }

    cronometro = CronometroService(
      tempoMaximo: tempoMaximo,
      onTick: (tempo) {
        if (!mounted) return;
        setState(() {
          tempoRestante = tempo;
        });
      },
      onTimeout: () {
        if (!mounted) return;
        responderTempoEsgotado();
      },
    );

    cronometro.iniciar();
  }

  // NOVA FUNÇÃO: Exibe o pop-up de acerto
  void mostrarSucesso() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.green.shade50, // Um fundo levemente esverdeado
          content: Column(
            mainAxisSize: MainAxisSize.min, // Faz o pop-up abraçar o conteúdo
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80, // Ícone bem grande e chamativo
              ),
              const SizedBox(height: 15),
              const Text(
                "Você acertou!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o pop-up
                    proximaPergunta(); // Avança para a próxima
                  },
                  child: const Text(
                    "Próxima Pergunta",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void mostrarErro() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.red.shade50,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 80,
              ),
              const SizedBox(height: 15),
              const Text(
                "Você errou!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    proximaPergunta();
                  },
                  child: const Text(
                    "Próxima Pergunta",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void mostrarTempoEsgotado() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.orange.shade50,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timer_off,
                color: Colors.orange,
                size: 80,
              ),
              const SizedBox(height: 15),
              const Text(
                "Tempo Esgotado!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Você não respondeu a tempo.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    proximaPergunta();
                  },
                  child: const Text(
                    "Próxima Pergunta",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // NOVA FUNÇÃO: Exibe o pop-up educativo
  void mostrarExplicacao(String? textoExplicativo, String titulo) {
    if (textoExplicativo == null || textoExplicativo.isEmpty) {
      if (titulo == "Resposta Incorreta") {
        mostrarErro();
      } else if (titulo == "Tempo Esgotado!") {
        mostrarTempoEsgotado();
      }

      return;
    }

    Color cor;
    Color corFundo;
    IconData icone;

    if (titulo == "Resposta Incorreta") {
      cor = Colors.red;
      corFundo = Colors.red.shade50;
      icone = Icons.cancel;
    } else if (titulo == "Tempo Esgotado!") {
      cor = Colors.orange;
      corFundo = Colors.orange.shade50;
      icone = Icons.timer_off;
    } else {
      cor = Colors.blue;
      corFundo = Colors.blue.shade50;
      icone = Icons.info_outline;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: corFundo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: Row(
            children: [
              Icon(
                icone,
                color: cor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(
                    color: cor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          content: SingleChildScrollView(
            child: Text(
              textoExplicativo,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),

          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  proximaPergunta();
                },
                child: const Text(
                  "Entendi, continuar",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void responderTempoEsgotado() {
    if (respondeu) return;
    respondeu = true;

    // Chama o pop-up passando a explicação da pergunta atual
    mostrarExplicacao(perguntas[indice].explicacao, "Tempo Esgotado!");
  }

  void proximaPergunta() {
    if (indice < perguntas.length - 1) {
      setState(() {
        indice++;
        respondeu = false;
        tempoRestante = tempoMaximo;
      });
      cronometro.iniciar();
    } else {
      cronometro.parar();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TelaResultado(
            pontuacao: pontuacao,
            total: perguntas.length,
          ),
        ),
      );
    }
  }

  void responder(bool escolha) {
    if (respondeu) return;
    respondeu = true;
    cronometro.parar();

    bool correta = perguntas[indice].resposta;

    if (escolha == correta) {
      pontuacao++;

      // Aqui está a grande mudança: chama o pop-up de sucesso!
      mostrarSucesso();

    } else {
      // Se errou, abre o pop-up educativo
      mostrarExplicacao(perguntas[indice].explicacao, "Resposta Incorreta");
    }
  }

  @override
  void dispose() {
    cronometro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pergunta = perguntas[indice];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fato ou Fake"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade700,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Pergunta ${indice + 1} de ${perguntas.length}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(
              value: tempoRestante / tempoMaximo,
              minHeight: 12,
              borderRadius: BorderRadius.circular(20),
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                tempoRestante > 6
                    ? Colors.green
                    : tempoRestante > 3
                    ? Colors.orange
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "$tempoRestante s",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: tempoRestante > 6
                    ? Colors.green
                    : tempoRestante > 3
                    ? Colors.orange
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    pergunta.imagem,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              pergunta.descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  disabledBackgroundColor: Colors.green.shade300,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: respondeu ? null : () => responder(true),
                child: const Text(
                  "FATO",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  disabledBackgroundColor: Colors.red.shade300,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: respondeu ? null : () => responder(false),
                child: const Text(
                  "FAKE",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Pontuação: $pontuacao",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}