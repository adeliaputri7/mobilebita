import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilebita/beranda_page.dart';
import 'profil_page.dart';
import 'package:mobilebita/screens/register_screens.dart';
import 'package:mobilebita/screens/kamus/alfabet.dart';
import 'package:mobilebita/screens/kamus/kata_kerja.dart';
import 'package:mobilebita/screens/kamus/kata_sifat.dart';
import 'package:mobilebita/screens/kamus/kata_tanya.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil App',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/profil', page: () => const ProfilPage()),
        GetPage(name: '/beranda', page: () => const BerandaPage()),
        GetPage(name: '/alfabet', page: () =>  AlfabetScreen()),
        GetPage(name: '/kata_kerja', page: () =>  KataKerjaScreen()),
        GetPage(name: '/kata_sifat', page: () =>  KataSifat()),
        GetPage(name: '/kata_tanya', page: () =>  KataTanyaScreen()),
      ],
    );
  }
}
