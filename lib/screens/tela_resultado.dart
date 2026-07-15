// Arquivo: lib/screens/tela_resultado.dart
import 'package:flutter/material.dart';
import 'tela_home.dart'; // Importa a tela inicial para poder reiniciar

class TelaResultado extends StatelessWidget {
  final int pontuacao;
  final int total;

  TelaResultado({required this.pontuacao, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            Text("Resultado Final", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Você acertou $pontuacao de $total!", style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TelaHome()),
                );
              },
              child: Text("VOLTAR AO INÍCIO"),
            )
          ],
        ),
      ),
    );
  }
}