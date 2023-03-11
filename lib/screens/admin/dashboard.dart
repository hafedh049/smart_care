import 'package:flutter/material.dart';
import 'package:smart_care/stuff/globals.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: darkBlue,
      body: Column(
        children: const <Widget>[],
      ),
    );
  }
}
