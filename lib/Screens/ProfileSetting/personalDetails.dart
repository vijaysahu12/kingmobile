import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Helpers/httpRequest.dart';
import '../../Helpers/sharedPref.dart';
import '../Common/refreshtwo.dart';
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
  final TextEditingController _userCityController = TextEditingController();
  final TextEditingController _userDateOfBirthController =
      TextEditingController();
  //HttpRequestHelper _httpHelper = HttpRequestHelper();

  final _formKey = new GlobalKey<FormState>();
  SharedPref _sharedPref = SharedPref();
  String? selectedGender;
  File? _image;
  DateTime selectedDate = DateTime.now();
  // bool isConnected =_httpHelper.checkInternetConnection(context);
  Future<void> _selectedDate() async {
    // DateTime? picked = await showDatePicker(
    //     context: context,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime(1950),
    //     lastDate: DateTime.now());
    // if (picked != null) {
    //   String formattedDate = DateFormat("dd-MM-yyyy").format(picked);
    //   setState(() {
    //     _userDateOfBirthController.text = formattedDate;
    //   });
    // }
    DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(vertical: 5),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.lightShadow,
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                  _userDateOfBirthController.text =
                      DateFormat('dd-MMM-yyyy').format(selectedDate);
                  print(selectedDate);
                });
              },
              minimumYear: 1930,
              //maximumYear: 2023,
            ),
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  handleRadioValueChange(String? value) {
    if (value != null) {
      setState(() {
        selectedGender = value;
        _sharedPref.save("KingUserProfileGender", selectedGender);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _userNameController.text =
        (await _sharedPref.read("KingUserProfileName") ?? '')
            .replaceAll('"', '');
    _userEmailController.text =
        (await _sharedPref.read("KingUserProfileEmail") ?? '')
            .replaceAll('"', '');
    _userMobileController.text =
        (await _sharedPref.read("KingUserProfileMobile") ?? '')
            .replaceAll('"', '');
    _userCityController.text =
        (await _sharedPref.read("KingUserProfileCity") ?? '')
            .replaceAll('"', '');
    _userDateOfBirthController.text =
        (await _sharedPref.read("KingUserProfileDateOfBirth") ?? '')
            .replaceAll('"', '');

    String? savedGender =
        (await _sharedPref.read("KingUserProfileGender") ?? '')
            .replaceAll('"', '');
    if (savedGender != null) {
      setState(() {
        selectedGender = savedGender;
      });
    }
  }

  Future<void> refreshData() async {
    await _loadUserData();
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

  //  Future<void> _pickImageCamera() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? pickedImage =
  //       await _picker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     if (pickedImage != null) {
  //       _image = File(pickedImage.path);
  //     }
  //   });
  // }

  // Future<void> _selectDOB() async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.lightShadow,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshHelper.buildRefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Form(
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
                Container(
                  height: MediaQuery.of(context).size.height / 1.20,
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
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
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
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.lightShadow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              readOnly: true,
                              controller: _userDateOfBirthController,
                              onTap: () {
                                _selectedDate();
                              },
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
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: 4), // Adjust margin for space
                                      child: Text(
                                        'Mobile Number *',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.cyan,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightShadow,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        readOnly: true,
                                        controller: _userMobileController,
                                        keyboardType: TextInputType.phone,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dark,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Mobile Number ',
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        'City',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.cyan,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightShadow,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        controller: _userCityController,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dark,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'City',
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
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
                        height: 20,
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  String fullName = _userNameController.text;
                                  String email = _userEmailController.text;
                                  String mobile = _userMobileController.text;
                                  String city = _userCityController.text;
                                  String dateOfBirth =
                                      _userDateOfBirthController.text;

                                  _sharedPref.save(
                                      "KingUserProfileName", fullName);
                                  _sharedPref.save(
                                      "KingUserProfileEmail", email);
                                  _sharedPref.save(
                                      "KingUserProfileMobile", mobile);
                                  _sharedPref.save("KingUserProfileCity", city);
                                  _sharedPref.save("KingUserProfileDateOfBirth",
                                      dateOfBirth);

                                  setState(() async {
                                    bool isConnected = await HttpRequestHelper
                                        .checkInternetConnection(context);
                                    if (isConnected) {
                                      Navigator.pop(context);
                                    }
                                  });
                                });
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
                                elevation: 20,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
