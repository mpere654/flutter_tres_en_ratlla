import 'package:flutter/material.dart';
import '../../players/screens/pantalla_seleccio_jugadors.dart';

// Aquesta pantalla és l'"Splash Screen", la pantalla de càrrega inicial.
// Uso StatefulWidget perquè necessito iniciar un temporitzador en l'estat.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Afegeixo SingleTickerProviderStateMixin per poder fer servir animacions.
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Variables per controlar l'animació
  late AnimationController _controladorAnimacio;
  late Animation<double> _animacioMida;

  // Aquesta funció es crida automàticament quan la pantalla es crea per primera vegada.
  @override
  void initState() {
    super.initState();
    
    // Configuro l'animació perquè duri 1 segon i es vagi repetint endavant i enrere.
    _controladorAnimacio = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Fa que s'ampliï i es redueixi contínuament.

    // Defineixo quant creixerà i decreixerà (des de la mida normal 0.8 fins a 1.2 vegades més gran).
    _animacioMida = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controladorAnimacio,
        curve: Curves.easeInOut,
      ),
    );

    // Aquí creo un "Future.delayed" que espera 6 segons i després canvia de pantalla.
    Future.delayed(const Duration(seconds: 6), () {
      // faig servir Navigator.pushReplacement per canviar a la pantalla de jugadors.
      // "pushReplacement" fa que no es pugui tornar a l'splash screen donant-li al botó d'enrere d'Android.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PantallaSeleccioJugadors(),
        ),
      );
    });
  }

  // Molt important: hem d'alliberar el controlador d'animació quan tanquem la pantalla per no gastar memòria.
  @override
  void dispose() {
    _controladorAnimacio.dispose();
    super.dispose();
  }

  // Aquesta funció construeix la interfície visual de l'Splash Screen.
  @override
  Widget build(BuildContext context) {
    // Scaffold és l'estructura bàsica de la pantalla.
    return Scaffold(
      backgroundColor: Colors.blueAccent, // Li poso un fons de color blau.
      // Center serveix per centrar el que posi a dins, tant verticalment com horitzontalment.
      body: Center(
        // Column em permet posar diverses coses una sota l'altra.
        child: Column(
          // Això centra els elements de la columna al mig de la pantalla.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Una icona gran d'un joc per decorar animada amb l'ScaleTransition.
            ScaleTransition(
              scale: _animacioMida,
              child: const Icon(Icons.videogame_asset, size: 100, color: Colors.white),
            ),
            // Un espai buit de 20 píxels.
            const SizedBox(height: 20),
            // El text de la meva aplicació.
            const Text(
              'Tres en Ratlla',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Una rodeta de càrrega animada perquè l'usuari sàpiga que està carregant.
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
