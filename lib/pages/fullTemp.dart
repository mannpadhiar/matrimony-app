import 'package:flutter/material.dart';

import '../utils.dart';

class TempFile extends StatelessWidget {
  const TempFile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {
          fetchDataFromApi();
        }, child: Text('press')),
      ),
    );
  }
}
