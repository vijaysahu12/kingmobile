import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:kraapp/Screens/login_and_register/login_screen.dart';

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
//   SharedPref _sharedPref = SharedPref();

//   @override
//   void initState() async {
//     super.initState();
//     //final tokenValue = await _sharedPref.read(SessionConstants.Token);
//     bool isLoggedIn = false;

//     // if (tokenValue != '') {
//     //   isLoggedIn = true;
//     // }

// // isLoggedIn ? HomeScreen() :
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LoginScreen(),
//       ),
//     );
//     // Timer(Duration(seconds: 15), () {

//     // });
//   }

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
