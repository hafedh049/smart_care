import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_care/get_started/get_started.dart';
import 'package:health_care/stuff/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;
  Animate.defaultCurve = Curves.linear;
  Animate.defaultDuration = 500.milliseconds;
  runApp(const Main());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: <SystemUiOverlay>[]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: transparent));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const GetStarted(),
    );
  }
}
