import 'package:flutter/material.dart';
import 'package:trabalho_pratico_flutter/creditos_screen.dart';
import 'package:trabalho_pratico_flutter/locais_screen.dart';
import 'package:trabalho_pratico_flutter/maisVisitados_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trabalho_pratico_flutter/mapas_screen.dart';
import 'firebase_options.dart';


void initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //initFirebase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP Local',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      initialRoute: MyHomePage.routeName,
      routes: {
        MyHomePage.routeName: (context) => const MyHomePage(
          title: "Amov Flutter",
        ),
        LocaisScreen.routeName: (context) => const LocaisScreen(),
        CreditosScreen.routeName: (context) => const CreditosScreen(),
        MaisVisitadosScreen.routeName: (context) => const MaisVisitadosScreen(),
        MapasScreen.routeName: (context) => const MapasScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  static const String routeName = '/';


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.outline,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    LocaisScreen.routeName,
                  );
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                child: const Text(
                  "Locais de Interesse",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    MaisVisitadosScreen.routeName,
                  );
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                child: const Text(
                  "Lugares Mais Visitados",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CreditosScreen.routeName);
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                child: const Text(
                  "Creditos",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(MapasScreen.routeName);
                },
                style:
                ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                child: const Text(
                  "Mapas",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, String label, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(label),
    );
  }
}
