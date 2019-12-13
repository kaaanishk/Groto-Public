import 'package:flutter/material.dart';

class ComingSoonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Groto',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'NotoSerif',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: Center(child: Text('Feature Coming Soon')),
    );
  }
}
