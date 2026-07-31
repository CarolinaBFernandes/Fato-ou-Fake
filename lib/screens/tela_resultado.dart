// Arquivo: lib/screens/tela_resultado.dart
import 'package:flutter/material.dart';
import 'tela_home.dart';

class TelaResultado extends StatelessWidget {
  final int pontuacao;
  final int total;

  const TelaResultado({super.key, required this.pontuacao, required this.total});

  @override
  Widget build(BuildContext context) {
    // Lógica para definir a mensagem e o ícone com base no desempenho
    double porcentagem = pontuacao / total;
    String mensagemDesempenho;
    IconData iconeDesempenho;
    Color corIcone;

    if (porcentagem >= 0.8) {
      mensagemDesempenho = "EXCELENTE!";
      iconeDesempenho = Icons.emoji_events; // Troféu
      corIcone = Colors.amber;
    } else if (porcentagem >= 0.5) {
      mensagemDesempenho = "BOM TRABALHO!";
      iconeDesempenho = Icons.thumb_up_alt_outlined; // Joinha
      corIcone = Colors.blue.shade300;
    } else {
      mensagemDesempenho = "CONTINUE ESTUDANDO!";
      iconeDesempenho = Icons.menu_book; // Livro
      corIcone = Colors.orange.shade300;
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // Mantendo o mesmo gradiente institucional da TelaHome
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003066),
              Color(0xFF001533),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconeDesempenho,
              size: 100,
              color: corIcone,
            ),
            const SizedBox(height: 20),

            const Text(
              "RESULTADO FINAL",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              mensagemDesempenho,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            // Caixa de destaque para a pontuação
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    "Sua Pontuação",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[100],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$pontuacao / $total",
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 70),

            // Botão com o mesmo design estruturado da TelaHome
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF003066),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              onPressed: () {
                // Usar pushAndRemoveUntil limpa o histórico de navegação para não pesar a memória
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TelaHome()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                "VOLTAR AO INÍCIO",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}