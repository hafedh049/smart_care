import 'package:flutter/material.dart';
import '../stuff/classes.dart';
import '../stuff/globals.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setS) {
        return Scaffold(
          key: homeScaffoldKey,
          drawer: HealthDrawer(
            func: () {
              homeScaffoldKey.currentState!.closeDrawer();
              setS(() {});
            },
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const <Widget>[]),
            ),
          ),
        );
      },
    );
  }
}
