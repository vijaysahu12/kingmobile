// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kraapp/Screens/all_screens.dart';
import 'package:kraapp/Services/Helpers/httpRequest.dart';
import 'package:kraapp/Services/Helpers/sharedPref.dart';

import 'package:kraapp/app_color.dart';
//import 'package:kraapp/Screens/login_and_register/register_screen.dart';

import 'package:kraapp/Services/Helpers/prodUrl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _useremailError = false;
  bool _userPassword = false;
  HttpRequestHelper _httpHelper = HttpRequestHelper();

  void _handleSignInWithEmailPassword() async {
    if (_formKey.currentState!.validate()) {
      print("login button is clicked");
      if (_isChecked) {
        String _emailOrMobile = _usernameController.text;
        String _password = _passwordController.text;

        if (_emailOrMobile.isEmpty || _password.isEmpty) {
          setState(() {
            _useremailError = _emailOrMobile.isEmpty;
            _userPassword = _password.isEmpty;
          });
          return;
        }

        final apiUrl = ApiConstants.baseUrl +
            ApiConstants.login +
            '?userName=$_emailOrMobile&password=$_password';

        // final response = await http.get(Uri.parse(apiUrl));
        final response = await _httpHelper.getWithOutToken(apiUrl);

        SharedPref _sharedPref = SharedPref();

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);

          if (jsonResponse.containsKey('statusCode') &&
              jsonResponse['statusCode'] == 200) {
            _sharedPref.save("KingUserId", jsonResponse['data']["publicKey"]);
            _sharedPref.save("KingUserToken", jsonResponse['data']["token"]);
            _sharedPref.save(
                "KingUserProfileImage", jsonResponse['data']["image"]);

            print(jsonResponse['data']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } else {
            String errorMessage = jsonResponse['message'];
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Failed'),
                  content: Text(errorMessage),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          print('API Request Failed with status code: ${response.statusCode}');
        }
      }
    }
  }

  // GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  // FacebookAuth facebookAuth = FacebookAuth.instance;
  // Future<void> _handleSignInWithGoogle() async {
  //   print('check');
  //   try {
  //     print('hello 1');
  //     final GoogleSignInAccount? account = await _googleSignIn.signIn();
  //     print('hello');
  //     if (account != null) {
  //       _name = account.displayName;
  //       _email = account.email;
  //       printUserData();
  //       print('user is Signed in with Google');
  //       // Navigator.push(
  //       //     context,
  //       //     MaterialPageRoute(
  //       //       builder: (context) => HomeScreen(),
  //       //     ));
  //     }
  //   } catch (error) {
  //     print('Error signing with Google: $error');
  //   }
  // }

  // Future<void> _handleSignInWithFaceBook() async {
  //   try {
  //     final LoginResult result = await facebookAuth.login();
  //     if (result.status == LoginStatus.success) {
  //       final AccessToken accessToken = result.accessToken!;
  //       print(accessToken);
  //     }
  //   } catch (error) {
  //     print('Error signing with facebook');
  //   }
  // }

  bool _isChecked = false;
  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _toggleCheckBox(bool? value) {
    if (value != null) {
      setState(() {
        _isChecked = value;
      });
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.dark,
                        fontWeight: FontWeight.w600, //w600 is semibold
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins',
                            color: AppColors.dark,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Hello There, Sign in to Continue',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey,
                            fontSize: 16,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightShadow, // Background color
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _useremailError
                                ? Colors.red
                                : AppColors
                                    .lightShadow, // Change border color based on error
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.phone_iphone_outlined,
                                  color: AppColors.dark,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _usernameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        setState(() {
                                          _useremailError = true;
                                        });
                                      } else if (!RegExp(r'^\d{10}$')
                                              .hasMatch(value) &&
                                          !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                              .hasMatch(value)) {
                                        setState(() {
                                          _useremailError = true;
                                        });
                                      } else {
                                        setState(() {
                                          _useremailError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _usernameController =
                                          value! as TextEditingController;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Email or Mobile',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightShadow, // Background color
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _userPassword
                                ? Colors.red
                                : AppColors
                                    .lightShadow, // Change border color based on error
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              Icons.lock_outline,
                              color: AppColors.dark,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _isObscured,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      _userPassword = true;
                                    });
                                  } else {
                                    setState(() {
                                      _userPassword = false;
                                    });
                                  }
                                  // if (!RegExp(
                                  //         r'^(?=.*[!@#\$%^&*(),.?":{}|<>])[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]{8,}$')
                                  //     .hasMatch(value!)) {
                                  //   _userPassword = true;
                                  // }
                                  return null;
                                },
                                onSaved: (value) {
                                  _passwordController =
                                      value! as TextEditingController;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: _isObscured
                                  ? Icon(Icons.visibility_off_outlined)
                                  : Icon(Icons.visibility_outlined),
                              color: AppColors.dark,
                              onPressed: _togglePasswordVisibility,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      child: Checkbox(
                        value: _isChecked,
                        onChanged: _toggleCheckBox,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(fontSize: 14, fontFamily: 'poppins'),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ElevatedButton(
                        onPressed: _handleSignInWithEmailPassword,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 100,
                          ),
                          elevation: 20,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: AppColors.lightShadow,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t Have an Account?',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => RegisterScreen(),
                        //   ),
                        // );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          color: AppColors
                              .primaryColor, // You can set any color you want
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Center(
                //       child: Text(
                //         'Or Signin with Google',
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontFamily: 'poppins',
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       height: 15,
                //     ),
                //     Container(
                //       width: double.infinity,
                //       height: 40,
                //       child: OutlinedButton.icon(
                //         onPressed: _handleSignInWithGoogle,
                //         style: OutlinedButton.styleFrom(
                //           side: BorderSide(color: AppColors.dark, width: 1),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //         icon: Image.asset(
                //           'images/google_icon.png',
                //           height: 24,
                //           width: 24,
                //         ),
                //         label: Text(
                //           'Google',
                //           style: TextStyle(
                //               color: AppColors.dark,
                //               fontSize: 16,
                //               fontFamily: 'poppins',
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       height: 15,
                //     ),
                //     Container(
                //       width: double.infinity,
                //       height: 40,
                //       child: ElevatedButton.icon(
                //         onPressed: _handleSignInWithFaceBook,
                //         style: OutlinedButton.styleFrom(
                //           backgroundColor: AppColors.blue,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //         icon: Image.asset('images/fb_icon.png',
                //             height: 24,
                //             width: 24,
                //             color: AppColors.lightShadow),
                //         label: Text(
                //           'Facebook',
                //           style: TextStyle(
                //               fontSize: 16,
                //               fontFamily: 'poppins',
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You have an account?',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w900,
                          color: AppColors
                              .purple, // You can set any color you want
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
