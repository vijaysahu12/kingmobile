import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../../Helpers/sharedPref.dart';
import '../Constants/app_color.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetails();
}

class _PersonalDetails extends State<PersonalDetails> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userMobileController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  SharedPref _sharedPref = SharedPref();
  String selectedGender = '';
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    _userNameController.text =
        (await _sharedPref.read("KingUserProfileName") ?? '')
            .replaceAll('"', '');
    _userEmailController.text =
        (await _sharedPref.read("KingUserProfileEmail") ?? '')
            .replaceAll('"', '');
    _userMobileController.text =
        (await _sharedPref.read("KingUserProfileMobile") ?? '')
            .replaceAll('"', '');
    selectedGender = await _sharedPref.read("SelectedGender") ?? '';
  }

  void handleRadioValueChange(String? value) {
    setState(() {
      selectedGender = value!;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: _image != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(_image!),
                      radius: 25,
                      backgroundColor: AppColors.lightShadow,
                    )
                  : CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                        'images/person_logo.png',
                      ),
                      backgroundColor: AppColors.light,
                    ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins',
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name of Card',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.cyan,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightShadow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _userNameController,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date of Birth',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.cyan,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightShadow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'DD/MM/YYYY',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                                      onChanged: handleRadioValueChange,
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
                                      onChanged: handleRadioValueChange,
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
                    SizedBox(height: 10),
                    Text(
                      'Contact Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins',
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mobile Number *',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.cyan,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightShadow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _userMobileController,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Mobile',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email ID *',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.cyan,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightShadow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _userEmailController,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email Id',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: AppColors.primaryColor,
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 100,
                              ),
                              elevation:
                                  20, // Set elevation to 0 to prevent double shadows
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: AppColors.lightShadow,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
