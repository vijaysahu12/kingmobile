// import 'dart:convert';

// import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:kraapp/Helpers/httpRequest.dart';
// import 'package:pusher_beams/pusher_beams.dart';

// import 'Helpers/ApiUrls.dart';
// import 'Helpers/sharedPref.dart';
// import 'Screens/Common/firebase_options.dart';
// import 'Screens/Common/useSharedPref.dart';
// import 'Screens/LoginRegister/loginRegisterNew/getOtpScreen.dart';
// import 'Screens/Notifications/allNotificationList.dart';
// import 'Screens/all_screens.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   // final List<String> latestSubscriptionList = await fetchSubscriptionTopics();

//   // await PusherBeams.instance.start('b16893bd-70f8-4868-ba42-32e53e665741');
//   // List<String?> currentSubscriptionList =
//   //     await PusherBeams.instance.getDeviceInterests();
//   // print(currentSubscriptionList);
//   // for (final topic in latestSubscriptionList) {
//   //   await PusherBeams.instance.addDeviceInterest(topic);
//   //   _firebaseMessaging.unsubscribeFromTopic(topic);
//   // }

//   // for (final item in currentSubscriptionList) {
//   //   if (currentSubscriptionList.contains(item) &&
//   //       !latestSubscriptionList.contains(item)) {
//   //     await PusherBeams.instance.removeDeviceInterest(item.toString());

//   //     _firebaseMessaging.unsubscribeFromTopic(item.toString());
//   //   }
//   // }

//   // List<String?> asd = await PusherBeams.instance.getDeviceInterests();
//   // print(asd);
//   await initializePusherBeams();
//   await initializeNotifications();
//   runApp(const MyApp());
// }

// Future<void> initializePusherBeams() async {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   await PusherBeams.instance.start('b16893bd-70f8-4868-ba42-32e53e665741');

//   final List<String> latestSubscriptionList = await fetchSubscriptionTopics();
//   final List<String?> currentSubscriptionList =
//       await PusherBeams.instance.getDeviceInterests();

//   for (final topic in latestSubscriptionList) {
//     await PusherBeams.instance.addDeviceInterest(topic);
//   }

//   for (final item in currentSubscriptionList) {
//     if (!latestSubscriptionList.contains(item)) {
//       await PusherBeams.instance.removeDeviceInterest(item.toString());
//       await _firebaseMessaging.unsubscribeFromTopic(item.toString());
//     }
//   }
// }

// GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// SharedPref _sharedPref = SharedPref();
// UsingHeaders usingHeaders = UsingHeaders();
// UsingSharedPref usingSharedPref = UsingSharedPref();

// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/launcher_icon');

//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await FirebaseAppCheck.instance.activate();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true, badge: true, sound: true);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//   );

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     handleNotificationTap(message);
//     // navigateToNotificationsScreen();
//   });

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     handleNotificationTap(message);
//   });
// }

// Future<List<String>> fetchSubscriptionTopics() async {
//   try {
//     final String? userKey = await _sharedPref.read(SessionConstants.UserKey);
//     if (userKey != null) {
//       final mobileUserKey = userKey.replaceAll('"', '');
//       final jwtToken = await usingSharedPref.getJwtToken();

//       if (jwtToken != null) {
//         Map<String, String> headers =
//             usingHeaders.createHeaders(jwtToken: jwtToken);
//         final apiUrl =
//             '${ApiUrlConstants.GetSubscriptionTopics}?userKey=$mobileUserKey';
//         final response = await http.get(Uri.parse(apiUrl), headers: headers);

//         if (response.statusCode == 200) {
//           final getSubscriptionData = jsonDecode(response.body);
//           final List<dynamic> topicList =
//               json.decode(getSubscriptionData['data']);
//           return topicList.map((topic) => topic['code'].toString()).toList();
//         } else {
//           throw Exception("Failed to fetch Subscription topics");
//         }
//       } else {
//         throw Exception("JWT Token is null");
//       }
//     } else {
//       throw Exception("User key is null");
//     }
//   } catch (e) {
//     print('Error fetching subscription topics: $e');
//     return []; // Return an empty list or handle the error accordingly
//   }
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   handleNotificationTap(message);
// }

// void handleNotificationTap(RemoteMessage message) {
//   if (message.data.containsKey("pusher")) {
//     showNotificationFromPusher(
//       message.notification!.title,
//       message.notification!.body,
//     );
//   } else if (message.from!.startsWith('/topics/')) {
//     showNotificationFromTopic(
//       message.notification?.title,
//       message.notification?.body,
//     );
//   } else {
//     showNotificationFromToken(
//       message.notification?.title,
//       message.notification?.body,
//     );
//   }
// }

// void navigateToNotificationsScreen() {
//   print("Notification Tapped");
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     Navigator.push(
//       navigatorKey.currentState!.context,
//       MaterialPageRoute(builder: (context) => AllNotifications()),
//     );
//   });
// }

// void showNotificationFromToken(String? title, String? body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     '126', // channel id
//     'TokenNotification', //channel name

//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   int id = DateTime.now().millisecondsSinceEpoch % 2147483647;
//   await flutterLocalNotificationsPlugin.show(
//     id,
//     title ?? 'Default Title',
//     body ?? 'Default Body',
//     payload: title,
//     platformChannelSpecifics,
//   );
// }

// void showNotificationFromTopic(String? title, String? body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     '123456', // channel id
//     'TopicNotification', //channel name
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   int id = DateTime.now().millisecondsSinceEpoch % 2147483647;
//   await flutterLocalNotificationsPlugin.show(
//     id,
//     'Default Tisdfsdffdstle',
//     'Default Body',
//     platformChannelSpecifics,
//   );
// }

// void showNotificationFromPusher(String? title, String? body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     '1456',
//     'PusherNotification',
//     importance: Importance.max,
//     priority: Priority.high,
//     sound: RawResourceAndroidNotificationSound('tone'),
//     playSound: true,
//     enableLights: true,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   int id = DateTime.now().millisecondsSinceEpoch % 2147483647;
//   await flutterLocalNotificationsPlugin.show(
//     id,
//     title ?? 'Default Title',
//     body ?? 'Default Body',
//     platformChannelSpecifics,
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool isLoggedIn = false;
//   SharedPref _sharedPref = SharedPref();

//   @override
//   void initState() {
//     super.initState();
//     checkLoginStatus();
//     initializeNotifications();
//   }

//   void checkLoginStatus() async {
//     String token = await _sharedPref.read("KingUserToken");
//     setState(() {
//       isLoggedIn = token.isNotEmpty;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScrollConfiguration(
//       behavior: ScrollBehavior(),
//       child: MaterialApp(
//         navigatorKey: navigatorKey,
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           body: isLoggedIn ? HomeScreen() : GetMobileOtp(),
//           // body: HomeScreen(),
//         ),
//         routes: {
//           '/notifications': (context) => AllNotifications(),
//         },
//       ),
//     );
//   }
// }