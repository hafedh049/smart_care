import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/get_started/get_started.dart';
import 'package:smart_care/languages/language_template.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/stuff/functions.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:smart_care/stuff/themes/dark_theme.dart';
import 'package:smart_care/stuff/themes/light_theme.dart';
import 'package:smart_care/wait/wait_room.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'error/error_room.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onMessage.listen((RemoteMessage event) => AwesomeNotifications().createNotification(content: NotificationContent(id: 10, channelKey: "basic_channel", body: event.notification!.body, title: event.notification!.title, actionType: ActionType.KeepOnTop)));
  Animate.restartOnHotReload = true;
  ErrorWidget.builder = (FlutterErrorDetails details) => ErrorRoom(error: details.exceptionAsString());

  await openDB();

  //COALESCE(field,default_value) => if field does not exists it returns the default passed value
  Map<String, dynamic> userData = (await db!.rawQuery("SELECT THEME_MODE, FIRST_TIME FROM SMART_CARE WHERE ID = 1;")).first;

  firstTime = userData["FIRST_TIME"];
  themeMode = userData["THEME_MODE"];

  await AwesomeNotifications().initialize(null, <NotificationChannel>[NotificationChannel(channelKey: "basic_channel", channelName: "Smart Care", channelDescription: "Welcome")]);
  await AwesomeNotifications().isNotificationAllowed().then((bool value) async => !value ? await AwesomeNotifications().requestPermissionToSendNotifications() : null);
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
        initial: themeMode == 1 ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
        builder: (ThemeData theme, ThemeData darkTheme) => GetMaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          translations: LanguageTemplateTranslation(),
          locale: const Locale("en", "US"),
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<FirebaseApp>(
            future: Firebase.initializeApp(),
            builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) => snapshot.hasError
                ? ErrorRoom(error: snapshot.error.toString())
                : snapshot.connectionState == ConnectionState.done
                    ? firstTime == 1
                        ? const GetStarted()
                        : FirebaseAuth.instance.currentUser == null
                            ? const SignIn()
                            : const Screens()
                    : const WaitRoom(),
          ),
        ),
      );
}
