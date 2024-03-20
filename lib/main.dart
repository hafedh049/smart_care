import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/get_started/get_started.dart';
import 'package:smart_care/languages/language_template.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/utils/callbacks.dart';
import 'package:smart_care/utils/globals.dart';
import 'package:smart_care/utils/themes/dark_theme.dart';
import 'package:smart_care/utils/themes/light_theme.dart';
import 'package:smart_care/wait/wait_room.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'error/error_room.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;
  ErrorWidget.builder = (FlutterErrorDetails details) => ErrorRoom(error: details.toString());

  await init();

  runApp(const Main());

  Connectivity().onConnectivityChanged.listen((ConnectivityResult event) async => await InternetConnectionChecker().hasConnection ? showToast(text: "Online".tr, color: blue) : showToast(text: "Offline".tr, color: red));

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: <SystemUiOverlay>[SystemUiOverlay.top]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, systemNavigationBarColor: transparent, systemNavigationBarContrastEnforced: false, systemNavigationBarDividerColor: transparent, systemNavigationBarIconBrightness: Brightness.light, systemStatusBarContrastEnforced: false));
}

class Main extends StatelessWidget {
  const Main({super.key});
  @override
  Widget build(BuildContext context) => AdaptiveTheme(
        light: lightTheme_,
        dark: darkTheme_,
        initial: userData!.get("dark_theme") ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
        builder: (ThemeData theme, ThemeData darkTheme) => GetMaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          translations: LanguageTemplateTranslation(),
          locale: const Locale("en", "US"),
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<FirebaseApp>(
            future: Firebase.initializeApp(
              options: const FirebaseOptions(
                apiKey: "AIzaSyAWbsPuogjLWkP6qPjDF1pjwDwota94rl8",
                appId: "1:326479825147:android:ebdb75917f5865afba485e",
                messagingSenderId: "326479825147",
                projectId: "smart-care-b4ab6",
              ),
            ),
            builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) => snapshot.hasError
                ? ErrorRoom(error: snapshot.error.toString())
                : snapshot.hasData
                    ? userData!.get("first_time")
                        ? const GetStarted()
                        : FirebaseAuth.instance.currentUser == null
                            ? const SignIn()
                            : const Screens()
                    : const WaitRoom(),
          ),
        ),
      );
}
