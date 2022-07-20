import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);
  static String route = "/no_internet";
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Connexion',
          style: TextStyle(
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0C2E8A),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
              // child: Lottie.asset('assets/connection-style-2.json'),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/no-internet.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const Text(
              "Pas de connexion Internet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Vous n'êtes pas connecté à Internet. Assurez-vous que le Wi-Fi est activé, le mode avion est désactivé et réessayez.",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
