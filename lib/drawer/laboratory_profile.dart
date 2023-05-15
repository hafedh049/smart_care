import 'package:flutter/material.dart';

import '../stuff/globals.dart';

class LaboratoryProfile extends StatelessWidget {
  const LaboratoryProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: darkBlue,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
