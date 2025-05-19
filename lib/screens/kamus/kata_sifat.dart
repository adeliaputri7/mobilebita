import 'package:flutter/material.dart';
import 'kata_sifatpage.dart';

class KataSifat extends StatelessWidget {
  final List<String> kataSifatList = [
    'Senang',
    'Sedih',
    'Besar',
    'Kecil',
    'Baik'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kata Sifat'),
        backgroundColor: Color(0xFF2C3E73),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: kataSifatList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              kataSifatList[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      KataSifatPage(kata: kataSifatList[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
