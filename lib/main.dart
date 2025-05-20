import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilebita/beranda_page.dart';
import 'profil_page.dart';
import 'package:mobilebita/screens/register_screens.dart';
import 'package:mobilebita/screens/login_screens.dart';
<<<<<<< Updated upstream
import 'alfabet.dart';
import 'kata_sifat.dart';
import 'kata_kerja.dart';
import 'kata_tanya.dart';
=======
import 'splash_screen.dart';
>>>>>>> Stashed changes

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // gunakan GetMaterialApp di sini
      debugShowCheckedModeBanner: false,
      title: 'Profil App',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/profil', page: () => const ProfilPage()),
      ],
    );
  }
}
