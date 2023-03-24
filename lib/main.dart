import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/get_started/get_started.dart';
import 'package:smart_care/l10n/l10n.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:smart_care/wait/wait_room.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'error/error_room.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;
  ErrorWidget.builder = (FlutterErrorDetails details) => ErrorRoom(error: details.exceptionAsString());
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  await openDB();
  Map<String, dynamic> userData = (await db!.rawQuery("SELECT FIRST_TIME,AUDIO FROM SMART_CARE WHERE ID = 1;")).first;
  firstTime = userData["FIRST_TIME"] as int;
  play = userData["AUDIO"] as int?;
  Connectivity().onConnectivityChanged.listen((ConnectivityResult event) async {
    if (await InternetConnectionChecker().hasConnection) {
      showToast("Online", color: blue);
    } else {
      showToast("Offline", color: red);
    }
  });
  runApp(const Main());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: <SystemUiOverlay>[SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: transparent,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarDividerColor: transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
  ));
}

class Main extends StatelessWidget {
  const Main({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: L10n.all,
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const <LocalizationsDelegate>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            return ErrorRoom(error: snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (firstTime == 1) {
              return const GetStarted();
            } else {
              return FirebaseAuth.instance.currentUser == null ? const SignIn() : const Screens(firstScreen: 0);
            }
          }
          return const WaitRoom();
        },
      ),
    );
  }
}
