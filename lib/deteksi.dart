import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  State<DeteksiPage> createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9C8C8), // Background pink muda
      body: Column(
        children: [
          Container(
            height: 40,
            color: Colors.transparent,
          ),
          Container(
            height: 60,
            color: const Color(0xFF2F4B78), // Garis biru atas
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white, // Area utama kosong (tempat karakter)
            ),
          ),
          Container(
            height: 60,
            color: const Color(0xFF2F4B78), // Garis biru bawah
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
