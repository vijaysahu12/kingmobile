import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pusher_beams/pusher_beams.dart';

import 'Helpers/sharedPref.dart';
import 'Screens/Common/firebase_options.dart';
// import 'Screens/LoginRegister/loginRegisterNew/getOtpScreen.dart';
import 'Screens/all_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  _firebaseMessaging.subscribeToTopic("binod");

  await PusherBeams.instance.start('b16893bd-70f8-4868-ba42-32e53e665741');
  await PusherBeams.instance.addDeviceInterest("pp");

  await FirebaseAppCheck.instance.activate();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle the incoming message here
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  SharedPref _sharedPref = SharedPref();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    initializeNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        showNotificationFromPusher(
            message.notification!.title, message.notification!.body);
      } else if (message.from!.startsWith('/topics/')) {
        print(
            'Received foreground message for topic: ${message.notification?.title}');
        showNotificationFromTopic(
            message.notification?.title, message.notification?.body);
      } else {
        print(
            'Received foreground message for token: ${message.notification?.title}');
        showNotificationFromToken(
            message.notification?.title, message.notification?.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.from!.startsWith('/topics/')) {
        print(
            'Opened app from background message: ${message.notification?.title}');
        showNotificationFromTopic(
            message.notification?.title, message.notification?.body);
      } else {
        showNotificationFromToken(
            message.notification?.title, message.notification?.body);
      }
    });
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotificationFromToken(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '126', // channel id
      'TokenNotification', //channel name
      importance: Importance.max,
      priority: Priority
          .high, //High priority suggests that the notification is urgent and should be shown to the user immediately.
      // sound: RawResourceAndroidNotificationSound("tone"),
      // playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    int id = DateTime.now().millisecondsSinceEpoch % 2147483647;
    await flutterLocalNotificationsPlugin.show(
      id,
      title ?? 'Default Title',
      body ?? 'Default Body',
      platformChannelSpecifics,
    );
  }

  Future<void> showNotificationFromTopic(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '123456', // channel id
      'TopicNotification', //channel name
      importance: Importance.max,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound('tone'),
      // playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    int id = DateTime.now().millisecondsSinceEpoch % 2147483647;
    await flutterLocalNotificationsPlugin.show(
      id,
      title ?? 'Default Title',
      body ?? 'Default Body',
      platformChannelSpecifics,
    );
  }

  Future<void> showNotificationFromPusher(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1456', // channel id
      'PusherNotification', //channel name
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('tone'),
      playSound: true,
      enableLights: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    int id = DateTime.now().millisecondsSinceEpoch % 2147483647;
    await flutterLocalNotificationsPlugin.show(
      id,
      title ?? 'Default Title',
      body ?? 'Default Body',
      platformChannelSpecifics,
    );
  }

  void checkLoginStatus() async {
    String token = await _sharedPref.read("KingUserToken");
    setState(() {
      isLoggedIn = token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // body: isLoggedIn ? HomeScreen() : GetMobileOtp(),
        body: HomeScreen(),
      ),
    );
  }
}
