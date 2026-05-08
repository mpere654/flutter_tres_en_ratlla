import 'package:flutter/material.dart';
import '../../game/screens/pantalla_joc.dart';

// Aquesta pantalla és on els jugadors posen els seus noms.
// És un StatefulWidget perquè les dades del formulari poden canviar mentre les escrivim.
class PantallaSeleccioJugadors extends StatefulWidget {
  // Aquestes dues variables serveixen per guardar els noms si venim de jugar una altra partida.
  // Són opcionals (per això tenen el ?) perquè la primera vegada que obrim l'app no hi ha noms previs.
  final String? nomJugador1Previ;
  final String? nomJugador2Previ;

  const PantallaSeleccioJugadors({
    super.key, 
    this.nomJugador1Previ, 
    this.nomJugador2Previ,
  });

  @override
  State<PantallaSeleccioJugadors> createState() => _PantallaSeleccioJugadorsState();
}

class _PantallaSeleccioJugadorsState extends State<PantallaSeleccioJugadors> {
  // clauFormulari és una clau única que em permet controlar el formulari i validar-lo (comprovar que no estigui buit).
  final clauFormulari = GlobalKey<FormState>();

  // Aquests controladors em serveixen per llegir exactament el que l'usuari escriu a les caixes de text.
  final controladorNom1 = TextEditingController();
  final controladorNom2 = TextEditingController();

  // Aquesta funció s'executa automàticament en iniciar la pantalla.
  @override
  void initState() {
    super.initState();
    // Si ja teníem noms d'abans, els poso a les caixes de text perquè no els hagin de tornar a escriure.
    if (widget.nomJugador1Previ != null) {
      controladorNom1.text = widget.nomJugador1Previ!;
    }
    if (widget.nomJugador2Previ != null) {
      controladorNom2.text = widget.nomJugador2Previ!;
    }
  }

  // És molt important alliberar els controladors quan la pantalla es tanca per no gastar memòria.
  @override
  void dispose() {
    controladorNom1.dispose();
    controladorNom2.dispose();
    super.dispose();
  }

  // Aquesta funció es crida quan li donem al botó de "Començar a Jugar".
  void iniciarPartida() {
    // Aquí comprovo si el formulari és vàlid (cridarà a la funció 'validator' de cada text).
    if (clauFormulari.currentState!.validate()) {
      // Si tot està bé, guardo els noms dels controladors a les meves variables en català.
      final nomJugador1 = controladorNom1.text;
      final nomJugador2 = controladorNom2.text;

      // I canvio de pantalla cap a la pantalla del joc, passant-li els noms.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaJoc(
            nomJugador1: nomJugador1,
            nomJugador2: nomJugador2,
          ),
        ),
      );
    }
  }

  // Aquesta és la part que pinta la pantalla.
  @override
  Widget build(BuildContext context) {
    // Scaffold ens dona la barra de dalt (AppBar) i el cos (body).
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noms dels Jugadors'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      // Ús de Padding perquè el contingut no estigui enganxat a les vores de la pantalla del mòbil.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Form és el giny que agrupa les meves caixes de text per poder validar-les juntes usant la 'clauFormulari'.
        child: Form(
          key: clauFormulari,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Caixa de text per al primer jugador.
              TextFormField(
                controller: controladorNom1, // Li associo el seu controlador per poder llegir el text.
                decoration: const InputDecoration(
                  labelText: 'Nom del Jugador 1 (X)', // El text que surt a dalt del requadre.
                  border: OutlineInputBorder(), // Li poso una vora bonica al voltant.
                  prefixIcon: Icon(Icons.person), // Una icona d'una persona.
                ),
                // Aquesta funció valida el que l'usuari ha escrit quan intentem guardar.
                validator: (valor) {
                  // Si el text està buit, retorno un missatge d'error en vermell.
                  if (valor == null || valor.isEmpty) {
                    return 'Si us plau, introdueix un nom';
                  }
                  return null; // Si tot està bé, retorno null i no dona error.
                },
              ),
              const SizedBox(height: 20), // Un espai en blanc entre les dues caixes.
              // Caixa de text per al segon jugador.
              TextFormField(
                controller: controladorNom2,
                decoration: const InputDecoration(
                  labelText: 'Nom del Jugador 2 (O)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Si us plau, introdueix un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40), // Més espai abans del botó.
              // Un botó gran per començar a jugar.
              SizedBox(
                width: double.infinity, // Faig que el botó ocupi tota l'amplada disponible.
                height: 50, // Altura del botó perquè es pugui tocar bé amb el dit.
                child: ElevatedButton(
                  onPressed: iniciarPartida, // Quan es prem, crido a la meva funció iniciarPartida.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Començar a Jugar', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
