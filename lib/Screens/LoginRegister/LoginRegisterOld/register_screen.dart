import 'package:flutter/material.dart';
import 'package:kraapp/Screens/LoginRegister/LoginRegisterOld/login_screen.dart';

import 'package:kraapp/Screens/LoginRegister/LoginRegisterOld/verification_screen.dart';

import '../../Constants/app_color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  bool _userEmailError = false;
  bool _userMobileError = false;
  bool _userPasswordError = false;
  String _email = '';
  String _mobile = '';
  String _password = '';
  String? _selectedCountryCode = '+91';
  List<String> _countryCodes = ['+1', '+91', '+44', '+81', '+86', '+61'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_email.isEmpty ||
          _mobile.isEmpty ||
          _password.isEmpty ||
          _userEmailError ||
          _userMobileError ||
          _userPasswordError) {
        return;
      }

      try {
        if (_isChecked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationScreen(),
            ),
          );
        }
      } catch (error) {
        print('Error registering: $error');
      }
    }
  }

  bool _isObscured = true;

  bool _isChecked = false;
  void _toggleCheckbox(bool? value) {
    if (value != null) {
      setState(() {
        _isChecked = value;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 17,
                          color: AppColors.dark,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome To Us',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins',
                              color: AppColors.dark),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Hello There,Create New Account',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightShadow,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _userMobileError
                                ? Colors.red
                                : AppColors
                                    .lightShadow, // Change border color based on error
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.dark,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      _userEmailError = true;
                                    });
                                  } else if (!RegExp(
                                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                      .hasMatch(value)) {
                                    setState(() {
                                      _userEmailError = true;
                                    });
                                  } else {
                                    _userEmailError = false;
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email Id',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightShadow,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _userMobileError
                                ? Colors.red
                                : AppColors
                                    .lightShadow, // Change border color based on error
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.phone_iphone_outlined,
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCountryCode,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCountryCode = newValue!;
                                    });
                                  },
                                  icon: SizedBox.shrink(),
                                  items: _countryCodes.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    _userMobileError = true;
                                  } else if (!RegExp(r'^\d{10}$')
                                      .hasMatch(value)) {
                                    _userMobileError = true;
                                  } else {
                                    _userMobileError = false;
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _mobile = value!;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Mobile',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightShadow,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _userPasswordError
                                ? Colors.red
                                : AppColors
                                    .lightShadow, // Change border color based on error
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.lock_outline,
                              color: AppColors.dark,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    _userPasswordError = true;
                                  } else if (!RegExp(
                                          r'^(?=.*[!@#\$%^&*(),.?":{}|<>])[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]{8,}$')
                                      .hasMatch(value)) {
                                    _userPasswordError = true;
                                  } else {
                                    _userPasswordError = false;
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _password = value!;
                                },
                                obscureText: _isObscured,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  // prefixIcon: Icon(
                                  //   Icons.lock_outline,
                                  //   color: AppColors.dark,
                                  // ),
                                  // suffixIcon: IconButton(
                                  //   icon: _isObscured
                                  //       ? Icon(Icons.visibility_off_outlined)
                                  //       : Icon(Icons.visibility_outlined),
                                  //   color: AppColors.dark,
                                  //   onPressed: _togglePasswordVisibility,
                                  // ),
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
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: _toggleCheckbox,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'By signing up, you\'re agreeing to our ',
                              style: TextStyle(
                                  color: AppColors.dark,
                                  fontFamily: 'poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          TextSpan(
                            text: 'Terms & Conditions and Privacy Policy.',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryColor,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 80,
                          ),
                          elevation: 20,
                        ),
                        child: Text(
                          'Register',
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
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already Have an Account?',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
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
