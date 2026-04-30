import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final int userId;       // Integer comme en Java
  final String token;     // JWT reçu au login

  const ProfilePage({super.key, required this.userId, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool darkMode = false;
  Map<String, dynamic>? userData;
  bool loading = true;
  String? error;

  // ── URL de base (10.0.2.2 = localhost depuis émulateur Android)
  static const String baseUrl = 'http://10.0.2.2:8080';

  @override
  void initState() {
    super.initState();
    fetchProfil();
  }

  // ── Charger le profil depuis le backend Java ──────────────
  Future<void> fetchProfil() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/clients/${widget.userId}'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',  // JWT
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
          loading = false;
        });
      } else {
        setState(() {
          error = "Erreur de chargement du profil";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Impossible de joindre le serveur";
        loading = false;
      });
    }
  }

  // ── Déconnexion ───────────────────────────────────────────
  void logout() {
    // On efface le token et on retourne à la page de login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  // ── Reset mot de passe ────────────────────────────────────
  Future<void> resetPassword() async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': userData!['email']}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Email de réinitialisation envoyé")),
        );
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text("Erreur lors de la réinitialisation")),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Impossible de joindre le serveur")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ── Chargement ─────────────────────────────────────────
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF4CD964)),
        ),
      );
    }

    // ── Erreur ─────────────────────────────────────────────
    if (error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(error!, style: const TextStyle(color: Colors.redAccent)),
        ),
      );
    }

    // ── Profil chargé ──────────────────────────────────────
    return Scaffold(
      backgroundColor: darkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CD964),
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Avatar + nom ───────────────────────────────
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF4CD964),
                    child: Text(
                      userData!['name'][0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userData!['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    userData!['profil'],
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Infos ──────────────────────────────────────
            _infoTile(Icons.email, "Email", userData!['email']),
            _infoTile(Icons.phone, "Téléphone", userData!['telephone']),

            const SizedBox(height: 24),
            const Divider(),

            // ── Paramètres ─────────────────────────────────
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: Text(
                "Mode sombre",
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                ),
              ),
              value: darkMode,
              activeColor: const Color(0xFF4CD964),
              onChanged: (_) => setState(() => darkMode = !darkMode),
            ),

            ListTile(
              leading: const Icon(Icons.lock_reset, color: Color(0xFF4CD964)),
              title: Text(
                "Changer de mot de passe",
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: resetPassword,
            ),

            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF4CD964)),
              title: Text(
                "À propos",
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: "Agriscan",
                applicationVersion: "1.0.0",
                children: const [
                  Text("Application de diagnostic agricole."),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Déconnexion",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper tuile info ──────────────────────────────────────
  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CD964), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                value,
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}