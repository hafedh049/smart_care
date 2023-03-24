import 'package:flutter/material.dart';
import 'package:smart_care/stuff/globals.dart';

class Laboratory extends StatelessWidget {
  const Laboratory({super.key});

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[SizedBox(height: 60)],
        ),
      ),
    );
  }
}
