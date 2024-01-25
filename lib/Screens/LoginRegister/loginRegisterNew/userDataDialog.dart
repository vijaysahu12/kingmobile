import 'package:flutter/material.dart';
import 'package:kraapp/Screens/Constants/app_color.dart';
import 'package:kraapp/Screens/all_screens.dart';

// ignore: must_be_immutable
class UserDataDialog extends StatefulWidget {
  final Function(String fullName, String email, String mobile, String city,
      String gender) onRegister;

  String mobile;
  UserDataDialog({
    required this.onRegister,
    required this.mobile,
  });

  @override
  _UserDataDialogState createState() => _UserDataDialogState();
}

class _UserDataDialogState extends State<UserDataDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedGender;

  @override
  void initState() {
    _mobileController.text = widget.mobile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        backgroundColor: AppColors.lightShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.cyan,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightShadow,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //     color: _usernameError
                            //         ? Colors.red
                            //         : AppColors.lightShadow),
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Your Name',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  // _usernameError = true;
                                });

                                return 'This field is required';
                              } else if (value.length < 4) {
                                setState(() {
                                  //  _usernameError = true;
                                });

                                return 'Enter Full Name';
                              } else {
                                // _usernameError = false;
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Id *',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                AppColors.cyan, // Customize the color if needed
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightShadow,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //   color: _useremailError
                            //       ? Colors.red
                            //       : AppColors.lightShadow,
                            // ),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Email Id',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //_useremailError = true;
                                return 'This field is required';
                              } else if (!RegExp(r'^\d{10}$').hasMatch(value) &&
                                  !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                      .hasMatch(value)) {
                                //  _useremailError = true;
                                return 'Enter Valid Email';
                              } else {
                                //  _useremailError = false;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mobile',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.cyan,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightShadow,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //   color: _userMobileError
                            //       ? Colors.red
                            //       : AppColors.lightShadow,
                            // ),
                          ),
                          child: TextFormField(
                            controller: _mobileController,
                            readOnly: true,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Mobile Number',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                // _userMobileError = true;
                                return 'This field is required';
                              } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                //_userMobileError = true;
                                return 'Enter 10digits valid number';
                              } else {
                                // _userMobileError = false;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'City',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                AppColors.cyan, // Customize the color if needed
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightShadow,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //   color: _cityErrorController
                            //       ? Colors.red
                            //       : AppColors
                            //           .lightShadow, // Change border color based on error
                            // ),
                          ),
                          child: TextFormField(
                            controller: _cityController,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Current City',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //  _cityErrorController = true;
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.cyan,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightShadow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Male',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Radio(
                                      value: 'Male',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value as String;
                                        });
                                      },
                                      activeColor: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.lightShadow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Female',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Radio(
                                      value: 'Female',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value as String;
                                        });
                                      },
                                      activeColor: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              String? fullName = _nameController.text;
                              String? email = _emailController.text;
                              String? mobile = _mobileController.text;
                              String? city = _cityController.text;
                              if (_formKey.currentState!.validate()) {
                                widget.onRegister(fullName, email, mobile, city,
                                    selectedGender!);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: AppColors.cyan,
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 80,
                              ),
                              elevation: 20,
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: AppColors.dark,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
