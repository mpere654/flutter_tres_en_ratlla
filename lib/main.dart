import 'package:flutter/material.dart';
import 'features/splash/screens/splash_screen.dart';

// Aquesta és la funció principal que arrenca la meva aplicació. 
// És el primer que s'executa quan obro l'app.
void main() {
  runApp(const LaMevaApp());
}

// Aquest és el giny (widget) principal de la meva aplicació. 
// És un StatelessWidget perquè la seva configuració no canvia un cop creat.
class LaMevaApp extends StatelessWidget {
  const LaMevaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp em dona l'estructura bàsica d'una app a Android.
    return MaterialApp(
      // Aquesta opció treu l'etiqueta vermella de "DEBUG" que surt a la cantonada superior dreta.
      debugShowCheckedModeBanner: false,
      // El títol de la meva aplicació.
      title: 'Tres en Ratlla',
      // Aquí configuro els colors i l'estil visual de la meva app.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // Aquesta opció indica quina serà la primera pantalla que es mostrarà a l'usuari.
      home: const SplashScreen(),
    );
  }
}
