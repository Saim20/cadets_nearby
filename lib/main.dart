import 'package:cadets_nearby/data/appData.dart';
import 'package:cadets_nearby/pages/cancel.dart';
import 'package:cadets_nearby/pages/dpModifier.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:cadets_nearby/pages/init.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/pages/reset.dart';
import 'package:cadets_nearby/pages/signup.dart';
import 'package:cadets_nearby/pages/verification.dart';
import 'package:cadets_nearby/pages/verifyCadet.dart';
import 'package:cadets_nearby/pages/verifyEmail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  'This channel is used for important notifications',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterNotificationPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('New background message : ${message.messageId}');
}

asyncProcessing() async {
  await flutterNotificationPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  try {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    print(e);
  }
  asyncProcessing();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'cadets_nearby',
      theme: lightTheme,
      routes: {
        '/': (context) => _initialized ? HomeSetterPage() : InitPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupMainPage(),
        '/reset': (context) => ResetPage(),
        '/cancel': (context) => CancelVerificationPage(),
        '/verifycadet': (context) => CadetVerificationPage(),
        '/verifyemail': (context) => EmailVerificationPage(),
        '/verification': (context) => VerificationPage(),
        '/dpchange': (context) => DpPage(),
      },
    );
  }
}
