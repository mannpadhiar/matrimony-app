import 'package:flutter/material.dart';

class temp extends StatefulWidget {
  const temp({super.key});

  @override
  State<temp> createState() => _tempState();
}

class _tempState extends State<temp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WELCONE'),),
      body: Text('at new page!'),
    );
  }
}
