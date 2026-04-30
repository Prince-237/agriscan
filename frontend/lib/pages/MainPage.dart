import 'package:flutter/material.dart';
import 'ProfilePageWrapper.dart';
import 'histor_page.dart';
import 'home_pages.dart';

class MainPage extends StatefulWidget {
  final int userId;
  final String token;

  const MainPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const HomeContentPage(),
      const HistoryPage(),
      ProfilePageWrapper(
        userId: widget.userId,
        token: widget.token,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Historique"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}