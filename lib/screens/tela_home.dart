import 'package:flutter/material.dart';
import 'tela_jogo.dart';

class TelaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // 1. Cores Institucionais: Gradiente focado no Azul Marinho escuro
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003066), // Azul padrão acadêmico
              Color(0xFF001533), // Azul bem escuro para o fundo
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2. Elemento Visual Acadêmico (Pode ser trocado pela logo da UFF depois)
            Icon(
                Icons.school_outlined,
                size: 70,
                color: Colors.white.withOpacity(0.9)
            ),
            SizedBox(height: 16),

            // 3. Cabeçalho Institucional
            Text(
              "UNIVERSIDADE FEDERAL FLUMINENSE",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
                letterSpacing: 2,
              ),
            ),

            SizedBox(height: 50),

            // 4. Título do Aplicativo (mais elegante e legível)
            Text(
              "FATO OU FAKE",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 4
                  )
                ],
              ),
            ),

            SizedBox(height: 8),

            // 5. Subtítulo descritivo
            Text(
              "Projeto Acadêmico Interativo",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[100],
                fontStyle: FontStyle.italic,
              ),
            ),

            SizedBox(height: 70),

            // 6. Botão com visual mais estruturado (menos arredondado)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF003066), // Texto no mesmo azul do fundo
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Borda mais formal
                ),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaJogo()),
                );
              },
              child: Text(
                "INICIAR",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}