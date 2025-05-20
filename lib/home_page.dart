import 'package:flutter/material.dart';
import 'beranda_page.dart';
import 'informasi_page.dart';
import 'profil_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BerandaPage(),
    const InformasiPage(),
    const ProfilPage(),
  ];

  // Fungsi custom menu item yang akan dipakai di custom bottom nav
  Widget _menuItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Panggil _menuItem dengan parameter isSelected sesuai index
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: _menuItem(Icons.home, 'Beranda', _selectedIndex == 0),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: _menuItem(Icons.book, 'Informasi', _selectedIndex == 1),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              child: _menuItem(Icons.person, 'Profil', _selectedIndex == 2),
            ),
          ],
        ),
      ),
    );
  }
}
