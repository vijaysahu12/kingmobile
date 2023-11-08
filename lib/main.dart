// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//import 'package:kraapp/Screens/all_screens.dart';
import 'package:kraapp/Screens/login_and_register/login_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool isLoggedIn = false;
  // late User user;

  // getLoggedInState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? value = prefs.getBool('isLoggedIn');

  //   if (value != null) {
  //     setState(() {
  //       isLoggedIn = value;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getLoggedInState();
  //   Timer(Duration(minutes: 15), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => isLoggedIn ? HomeScreen() : LoginScreen(),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 252, 251, 251),
        body: LoginScreen(),
      ),
    );
  }
}
