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

static const int tempoMaximo = 10;
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

void responderTempoEsgotado() {
if (respondeu) return;

respondeu = true;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
backgroundColor: Colors.orange,
content: Text("Tempo esgotado!"),
duration: Duration(milliseconds: 700),
),
);

Future.delayed(const Duration(milliseconds: 700), () {
proximaPergunta();
});
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

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
backgroundColor: Colors.green,
content: Text("Você acertou!"),
duration: Duration(milliseconds: 500),
),
);
} else {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
backgroundColor: Colors.red,
content: Text("Errou!"),
duration: Duration(milliseconds: 500),
),
);
}

Future.delayed(const Duration(milliseconds: 600), () {
proximaPergunta();
});
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