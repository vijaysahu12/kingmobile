import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:kraapp/Screens/all_screens.dart';

import 'Helpers/sharedPref.dart';
//import 'Screens/Common/firebase_options.dart';
import 'Screens/LoginRegister/loginRegisterNew/getOtpScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
      webProvider:
          ReCaptchaV3Provider('6LcnbCUpAAAAAH1zTC4rAg3XJbFA4343ngD31Y-6'),
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  SharedPref _sharedPref = SharedPref();
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    String Token = await _sharedPref.read("KingUserToken");
    setState(() {
      isLoggedIn = Token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: isLoggedIn ? HomeScreen() : GetMobileOtp(),
        // body: HomeScreen(),
      ),
    );
  }
}
