import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          "Ici sera le profil de l’utilisateur",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
