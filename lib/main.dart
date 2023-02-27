import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_care/get_started/get_started.dart';
import 'package:health_care/home/home.dart';
import 'package:health_care/stuff/functions.dart';
import 'package:health_care/stuff/globals.dart';
import 'package:health_care/wait/wait_room.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'Error/error_room.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;
  await openDB();
  Map<String, dynamic> userData = (await db!.rawQuery("SELECT FIRST_TIME,IS_ACTIVE FROM SMART_CARE WHERE ID = 1;")).first;
  firstTime = userData["FIRST_TIME"] as int;
  isActive = userData["IS_ACTIVE"] as int;
  Connectivity().onConnectivityChanged.listen((ConnectivityResult event) async {
    if (await InternetConnectionChecker().hasConnection) {
      showToast("Connection is On", color: Colors.greenAccent);
      await db!.update("SMART_CARE", <String, dynamic>{"IS_ACTIVE": 1});
      isActive = 1;
    } else {
      showToast("Connection is Off", color: Colors.redAccent);
      await db!.update("SMART_CARE", <String, dynamic>{"IS_ACTIVE": 0});
      isActive = 0;
    }
  });
  runApp(const Main());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: <SystemUiOverlay>[]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: transparent));
}

class Main extends StatelessWidget {
  const Main({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyCl2pvYrf-DwYhNfZe9VmzR1Ux-lj_Zyhg", appId: "1:922916622086:android:71dcbd968c9d4556c3d887", messagingSenderId: "922916622086", projectId: "medical-care-930d6")),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasData) {
            if (firstTime == 1) {
              return const GetStarted();
            } else {
              return StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot<User?> snap) {
                  if (snap.hasData) {
                    return const Home();
                  } else if (snap.connectionState == ConnectionState.waiting) {
                    return const WaitRoom();
                  } else {
                    return ErrorRoom(error: snap.error.toString());
                  }
                },
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const WaitRoom();
          } else {
            return ErrorRoom(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
