import 'package:flutter/material.dart';

class KataSifatPage extends StatelessWidget {
  final String kata;

  const KataSifatPage({Key? key, required this.kata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E73),
      appBar: AppBar(
        backgroundColor: Color(0xFF2C3E73),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CircleAvatar(
                backgroundColor: Color(0xFF2C3E73),
                child: Icon(Icons.replay, color: Colors.white),
              ),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Text(
              kata,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Text("Bisindo", style: TextStyle(color: Colors.black87)),
          Spacer(),
        ],
      ),
    );
  }
}
