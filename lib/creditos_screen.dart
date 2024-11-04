import 'package:flutter/material.dart';

class CreditosScreen extends StatefulWidget {
  const CreditosScreen({Key? key}) : super(key: key);
  static const String routeName = '/CreditosScreen';

  @override
  State<CreditosScreen> createState() => _CreditosScreenState();
}

class _CreditosScreenState extends State<CreditosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(title: const Text("Créditos")),
      body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 230),
              Hero(
                  tag: 'CenterTitleText',
                  child: Text(
                    "Arquiteturas Móveis",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
              Text(
                "2023/2024",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 160),
              Text(
                "Francisco Reis",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text("2019149992",
                style: TextStyle(
                  color: Colors.white,

                ),),
              SizedBox(height: 10),
              Text("Quevin Moderno",
                style: TextStyle(
                  color: Colors.white,

                ),),
              Text("2019135563",
                style: TextStyle(
                  color: Colors.white,

                ),),
              SizedBox(height: 10),
              Text("João Castro",
                style: TextStyle(
                  color: Colors.white,

                ),),
              Text("2019128258",
                style: TextStyle(
                  color: Colors.white,

                ),),
            ],
          )),
    );
  }
}