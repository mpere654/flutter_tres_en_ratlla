import 'package:flutter/material.dart';
import 'dart:math';
import '../../players/screens/pantalla_seleccio_jugadors.dart';

// Aquesta pantalla és on es juga al tres en ratlla.
class PantallaJoc extends StatefulWidget {
  // Rebo els noms dels jugadors de la pantalla del formulari.
  final String nomJugador1;
  final String nomJugador2;

  const PantallaJoc({
    super.key,
    required this.nomJugador1,
    required this.nomJugador2,
  });

  @override
  State<PantallaJoc> createState() => _PantallaJocState();
}

class _PantallaJocState extends State<PantallaJoc> with WidgetsBindingObserver {
  // 'tauler' és una llista de 9 buits per guardar 'X' o 'O'.
  List<String> tauler = List.filled(9, '');
  
  // 'jugadorActual' guarda qui està jugant ara mateix (comença el jugador 1, que és la 'X').
  String jugadorActual = 'X';
  
  // 'partidaAcabada' em serveix per saber si algú ha guanyat o han empatat, per bloquejar el tauler.
  bool partidaAcabada = false;
  
  // 'guanyador' guardarà el nom del que ha guanyat, o "Empat" si no guanya ningú.
  String guanyador = '';

  // Llista de missatges graciosos per quan tornem de segon pla.
  final List<String> missatgesBenvinguda = [
    "Ben tornat! No em diguis que t'havies quedat sense bateria?",
    "Ja tornes? El tauler t'estava trobant a faltar!",
    "Epa! Has anat a consultar l'estratègia a Google?",
    "Compte, que l'altre jugador ja estava fent trampes mentre no hi eres!",
    "Tornem-hi! A veure qui guanya aquesta vegada.",
    "Has tornat per guanyar o per tornar a marxar?",
    "Tic-tac, tic-tac... el temps passa i el tauler t'espera!",
  ];

  @override
  void initState() {
    super.initState();
    // Afegim l'observador per detectar canvis en el cicle de vida de l'app.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Treiem l'observador quan la pantalla es destrueix.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Si l'aplicació torna a estar en primer pla (resumed).
    if (state == AppLifecycleState.resumed) {
      final random = Random();
      final missatge = missatgesBenvinguda[random.nextInt(missatgesBenvinguda.length)];
      
      // Mostrem un SnackBar amb el missatge aleatori.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(missatge, style: const TextStyle(fontWeight: FontWeight.bold)),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orangeAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Aquesta funció s'executa cada vegada que algú toca una casella. Rep el número de la casella (índex del 0 al 8).
  void jugarTorn(int index) {
    // Si la casella ja té alguna cosa ('X' o 'O') o la partida ja ha acabat, no faig res (surto amb return).
    if (tauler[index] != '' || partidaAcabada) {
      return;
    }

    // setState li diu a Flutter que he canviat variables importants i que ha de redibuixar la pantalla.
    setState(() {
      // Poso la lletra del jugador actual a la casella que ha tocat.
      tauler[index] = jugadorActual;
      
      // Comprovo si amb aquesta jugada algú ha guanyat cridant a la meva funció.
      comprovarGuanyador();

      // Si la partida no ha acabat, li canvio el torn a l'altre jugador.
      if (!partidaAcabada) {
        if (jugadorActual == 'X') {
          jugadorActual = 'O';
        } else {
          jugadorActual = 'X';
        }
      }
    });
  }

  // Aquesta funció comprova totes les formes possibles de guanyar al tres en ratlla.
  void comprovarGuanyador() {
    // Aquestes són totes les combinacions de caselles que donen la victòria (files, columnes i diagonals).
    List<List<int>> combinacionsGuanyadores = [
      [0, 1, 2], // Primera fila
      [3, 4, 5], // Segona fila
      [6, 7, 8], // Tercera fila
      [0, 3, 6], // Primera columna
      [1, 4, 7], // Segona columna
      [2, 5, 8], // Tercera columna
      [0, 4, 8], // Diagonal principal
      [2, 4, 6], // Diagonal secundària
    ];

    // Reviso cadascuna de les combinacions possibles en un bucle 'for'.
    for (var combinacio in combinacionsGuanyadores) {
      String a = tauler[combinacio[0]];
      String b = tauler[combinacio[1]];
      String c = tauler[combinacio[2]];

      // Si les 3 caselles de la combinació són iguals i no estan buides, hi ha un guanyador.
      if (a != '' && a == b && a == c) {
        partidaAcabada = true; // Marco que la partida ha acabat.
        // Si ha guanyat la 'X', és el jugador 1. Si ha guanyat la 'O', és el jugador 2.
        if (a == 'X') {
          guanyador = widget.nomJugador1;
        } else {
          guanyador = widget.nomJugador2;
        }
        // Mostro una finestreta (Dialog) avisant del final.
        mostrarDialegFinal();
        return; // Surto de la funció perquè ja he trobat un guanyador.
      }
    }

    // Si ningú ha guanyat, comprovo si el tauler està ple provant si no queda cap buit ''.
    if (!tauler.contains('')) {
      partidaAcabada = true;
      guanyador = 'Empat';
      mostrarDialegFinal();
    }
  }

  // Aquesta funció mostra una finestra emergent quan la partida acaba.
  void mostrarDialegFinal() {
    // showDialog obre la finestreta per sobre de la pantalla.
    showDialog(
      // 'barrierDismissible: false' Evita que es pugui tancar la finestra tocant fora d'ella. Ens obliga a usar els botons!
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // AlertDialog és el tipus de finestra amb títol, text principal i botons d'acció.
        return AlertDialog(
          title: Text(guanyador == 'Empat' ? 'Hi ha hagut un Empat!' : 'Ha guanyat $guanyador!'),
          content: const Text('Voleu tornar a jugar?'),
          actions: [
            // Botó per tornar a jugar però DEMANANT NOUS noms.
            TextButton(
              onPressed: () {
                // Treu la finestreta actual de la pantalla.
                Navigator.of(context).pop();
                // Torno a la pantalla de selecció de noms sense passar-los els noms previs (estaran buits).
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PantallaSeleccioJugadors()),
                );
              },
              child: const Text('Nous jugadors'),
            ),
            // Botó per tornar a jugar MANTENINT els mateixos noms d'ara.
            ElevatedButton(
              onPressed: () {
                // Treu la finestreta de la pantalla.
                Navigator.of(context).pop();
                // En comptes de canviar de pantalla, simplement netejo les variables d'aquesta mateixa pantalla.
                reiniciarPartida();
              },
              child: const Text('Mantenir noms'),
            ),
          ],
        );
      },
    );
  }

  // Aquesta funció buida el tauler i reseteja les variables per jugar de nou aquí mateix.
  void reiniciarPartida() {
    setState(() {
      tauler = List.filled(9, ''); // Torno a omplir la llista de 9 buits.
      jugadorActual = 'X'; // Sempre comença la 'X'.
      partidaAcabada = false; // Trec el bloqueig de fi de partida.
      guanyador = ''; // Esborro el guanyador anterior.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Aquí calculo de qui és el torn per mostrar el seu nom en gran.
    String nomJugadorActual = jugadorActual == 'X' ? widget.nomJugador1 : widget.nomJugador2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tres en Ratlla'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Ho centro tot verticalment.
        children: [
          // Text gran que mostra de qui és el torn.
          Text(
            'Torn de: $nomJugadorActual ($jugadorActual)',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40), // Un espai per separar el text del tauler.
          
          // 'Expanded' fa que el tauler ocupi tot l'espai sobrant possible, de forma adaptable.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Un marge perquè el tauler no toqui les vores.
              child: GridView.builder(
                // Això configura la forma de quadrícula: 3 columnes, amb 10 píxels d'espai entre elles.
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10, // Espai horitzontal entre cel·les
                  mainAxisSpacing: 10,  // Espai vertical entre cel·les
                ),
                itemCount: 9, // Li dic que dibuixaré 9 caselles en total.
                // itemBuilder s'executa 9 vegades per dibuixar cadascuna de les 9 caselles (l'índex va de 0 a 8).
                itemBuilder: (context, index) {
                  // GestureDetector em permet detectar quan l'usuari toca una de les caselles amb el dit.
                  return GestureDetector(
                    onTap: () => jugarTorn(index), // Quan toquen, crido a la meva funció de jugar passant-li el número de casella.
                    
                    // Container és la capsa visual de la casella (el quadradet blau claret).
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100, // Color de fons de la casella.
                        borderRadius: BorderRadius.circular(10), // Vores arrodonides perquè quedi modern.
                      ),
                      child: Center(
                        // Mostro la 'X', la 'O' o res, segons el que estigui guardat a la meva llista 'tauler' en aquesta posició.
                        child: Text(
                          tauler[index],
                          style: TextStyle(
                            fontSize: 60, // Lletra molt gran per la X i la O.
                            fontWeight: FontWeight.bold,
                            // Un detall visual: si és X la pinto blava fosca, si és O la pinto vermella.
                            color: tauler[index] == 'X' ? Colors.blue.shade900 : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Un botó extra per si s'equivoquen i volen reiniciar la partida abans que acabi.
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ElevatedButton.icon(
              onPressed: reiniciarPartida, // Crida a la mateixa funció de buidar-ho tot.
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar Partida'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
