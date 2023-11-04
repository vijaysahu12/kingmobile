import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kraapp/app_color.dart';
import 'package:image_picker/image_picker.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetails();
}

class _PersonalDetails extends State<PersonalDetails> {
  String selectedGender = '';

  File? _image;

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
      body: Column(
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
                          color:
                              AppColors.cyan, // Customize the color if needed
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
                            hintText: 'Seshadri Kaku',
                            hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark),
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
                            hintText: '20-05-2002',
                            hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark),
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
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '(+91) 630-937-3318',
                            hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark),
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
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'kakuseshadri033@gmail.com',
                            hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark),
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
    );
  }
}
