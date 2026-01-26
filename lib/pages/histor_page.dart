import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          "Ici sera les historique de recherche",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
