import 'dart:convert';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kraapp/Helpers/httpRequest.dart';
import 'package:pusher_beams/pusher_beams.dart';

import 'Helpers/ApiUrls.dart';
import 'Helpers/sharedPref.dart';
import 'Screens/Common/firebase_options.dart';
import 'Screens/LoginRegister/loginRegisterNew/getOtpScreen.dart';
import 'Screens/Notifications/allNotificationList.dart';
import 'Screens/all_screens.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
SharedPref _sharedPref = SharedPref();

Future<void> showNotificationFromToken(String? title, String? body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '126', // channel id
    'TokenNotification', //channel name

    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  int id = DateTime.now().millisecondsSinceEpoch % 2147483647;
  await flutterLocalNotificationsPlugin.show(
    id,
    title ?? 'Default Title',
    body ?? 'Default Body',
    payload: title,
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<String> topics = await fetchSubscriptionTopics();

  await PusherBeams.instance.start('b16893bd-70f8-4868-ba42-32e53e665741');
  for (final topic in topics) {
    await PusherBeams.instance.addDeviceInterest(topic);
    _firebaseMessaging.subscribeToTopic(topic);
  }

  await FirebaseAppCheck.instance.activate();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(const MyApp());
}

Future<List<String>> fetchSubscriptionTopics() async {
  final String userKey = await _sharedPref.read(SessionConstants.UserKey);
  final mobileUserKey = userKey.replaceAll('"', '');
  final apiUrl =
      '${ApiUrlConstants.GetSubscriptionTopics}?userKey=${mobileUserKey}';
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final getSubscriptionData = jsonDecode(response.body);
    final List<dynamic> topicList = json.decode(getSubscriptionData['data']);
    return topicList.map((topic) => topic['code'].toString()).toList();
  } else {
    throw Exception("Failed to fetch Subscription topics");
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  if (message.data.isNotEmpty) {
    showNotificationFromPusher(
        message.notification!.title, message.notification!.body);
  } else if (message.from?.startsWith('/topics/') ?? false) {
    print('Opened app from background message: ${message.notification?.title}');
    showNotificationFromTopic(
        message.notification?.title, message.notification?.body);
  } else {
    showNotificationFromToken(
        message.notification?.title, message.notification?.body);
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (navigatorKey.currentState != null) {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => AllNotifications()),
      );
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  SharedPref _sharedPref = SharedPref();

  Future<void> initializeNotifications() async {
    bool isConnected = await HttpRequestHelper.checkInternetConnection(context);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (isConnected) {
        handleNotificationTap(message);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey.currentState != null) {
            Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(builder: (context) => AllNotifications()),
            );
          }
        });
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (isConnected) {
        handleNotificationTap(message);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey.currentState != null) {
            Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(builder: (context) => AllNotifications()),
            );
          }
        });
      }
    });
  }

  void handleNotificationTap(RemoteMessage message) {
    if (message.data.containsKey("pusher")) {
      showNotificationFromPusher(
        message.notification!.title,
        message.notification!.body,
      );
    } else if (message.from!.startsWith('/topics/')) {
      showNotificationFromTopic(
        message.notification?.title,
        message.notification?.body,
      );
    } else {
      showNotificationFromToken(
        message.notification?.title,
        message.notification?.body,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    initializeNotifications();
  }

  void checkLoginStatus() async {
    String token = await _sharedPref.read("KingUserToken");
    setState(() {
      isLoggedIn = token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: isLoggedIn ? HomeScreen() : GetMobileOtp(),
          // body: HomeScreen(),
        ),
        routes: {
          '/notifications': (context) => AllNotifications(),
        },
      ),
    );
  }
}
