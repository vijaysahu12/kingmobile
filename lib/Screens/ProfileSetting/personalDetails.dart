import 'dart:convert';
import 'dart:io';
// import 'package:device_info/device_info.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kraapp/Helpers/ApiUrls.dart';
import '../../Helpers/httpRequest.dart';
import '../../Helpers/sharedPref.dart';
import '../../Models/Response/UserDetailsResponse.dart';
import '../Common/refreshtwo.dart';
import '../Common/usingJwt_Headers.dart';
import '../Constants/app_color.dart';
import 'package:http/http.dart' as http;

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

  final _formKey = new GlobalKey<FormState>();
  SharedPref _sharedPref = SharedPref();
  String? selectedGender;
  File? _image;
  DateTime selectedDate = DateTime.now();
  UsingJwtToken usingJwtToken = UsingJwtToken();
  UsingHeaders usingHeaders = UsingHeaders();

// handleRadioValueChange(String? value) {
  //   if (value != null) {
  //     setState(() {
  //       selectedGender = value;
  //       _sharedPref.save("KingUserProfileGender", selectedGender);
  //     });
  //   }
  // }
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

  // Future<String?> getImei() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   try {
  //     if (Platform.isAndroid) {
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       print(androidInfo.androidId);
  //       return 'Device Type is Android  and AndroidID: ${androidInfo.androidId}';
  //     } else if (Platform.isIOS) {
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       return 'Device Type is IOS & IosId ${iosInfo.identifierForVendor}';
  //     }
  //   } catch (e) {
  //     print('Error getting IMEI: $e');
  //     return null;
  //   }
  //   return null;
  // }

  @override
  void initState() {
    super.initState();
    GetUserDetails();
    _loadUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<UserDetailsResponse>?> GetUserDetails() async {
    try {
      String userKey = await _sharedPref.read(SessionConstants.UserKey);
      String mobileKey = userKey.replaceAll('"', '');
      UsingJwtToken usingJwtToken = UsingJwtToken();
      final jwtToken = await usingJwtToken.getJwtToken();
      Map<String, String> headers =
          usingHeaders.createHeaders(jwtToken: jwtToken);
      final String apiUrl =
          '${ApiUrlConstants.GetUserDetails}?mobileUserKey=$mobileKey';
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic getUserData = json.decode(response.body);

        print('GetUserData: $getUserData');

        if (getUserData == null) {
          print('API response is null');
          return null;
        }
        if (getUserData.containsKey('data')) {
          if (getUserData['data'] is Map) {
            Map<String, dynamic> userDataMap = getUserData['data'];
            UserDetailsResponse userDetailsResponse =
                UserDetailsResponse.fromJson(userDataMap);
            return [userDetailsResponse];
          } else if (getUserData['data'] is List) {
            List<dynamic> getUsersData = getUserData['data'];
            List<UserDetailsResponse> list = getUsersData
                .map((userInfo) => UserDetailsResponse.fromJson(userInfo))
                .toList();
            return list;
          }
        } else {
          print('API response does not contain a data field');
          return null;
        }
      } else {
        print(
            'Failed to fetch GetUsersData. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }

    return null;
  }

  Future<void> _loadUserData() async {
    try {
      List<UserDetailsResponse>? userdetailsList = await GetUserDetails();
      if (mounted) {
        if (userdetailsList != null && userdetailsList.isNotEmpty) {
          UserDetailsResponse userDetailsResponse = userdetailsList.first;
          setState(() {
            _userNameController.text = userDetailsResponse.fullName;
            _userEmailController.text = userDetailsResponse.emailId;
            _userMobileController.text = userDetailsResponse.mobile;
            _userCityController.text = userDetailsResponse.city;
            _userDateOfBirthController.text = DateFormat('dd-MMM-yyyy')
                .format(userDetailsResponse.dob)
                .toString();

            selectedGender = userDetailsResponse.gender.toString();
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
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

  Future<void> updateUserData() async {
    String userKey = await _sharedPref.read(SessionConstants.UserKey);
    String mobileKey = userKey.replaceAll('"', '');
    final jwtToken = await usingJwtToken.getJwtToken();
    final String apiUrl = '${ApiUrlConstants.ManageUserDetails}';
    Map<String, String> headers =
        usingHeaders.createHeaders(jwtToken: jwtToken);

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    // Add form fields
    request.fields['publicKey'] = mobileKey;
    request.fields['fullName'] = _userNameController.text;
    request.fields['emailId'] = _userEmailController.text;
    request.fields['mobile'] = _userMobileController.text;
    request.fields['city'] = _userCityController.text;
    request.fields['gender'] = selectedGender.toString();
    request.fields['dob'] = _userDateOfBirthController.text;

    // Add file
    if (_image != null) {
      List<int> imageBytes = await _image!.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'profileImage',
        imageBytes,
        filename: 'profileImage.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print("Data is updated successfully!");
      } else {
        print('Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
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
                      : FutureBuilder<List<UserDetailsResponse>?>(
                          future: GetUserDetails(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              List<UserDetailsResponse>? userDetails =
                                  snapshot.data;
                              String? imgurl = userDetails![0].profileImage;

                              return CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    (imgurl != null && imgurl.isNotEmpty)
                                        ? NetworkImage(imgurl)
                                        : NetworkImage(
                                            'https://static.vecteezy.com/system/resources/previews/002/318/271/original/user-profile-icon-free-vector.jpg',
                                          ),
                                backgroundColor: AppColors.lightShadow,
                              );
                            } else {
                              return CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage('images/person_logo.png'),
                                backgroundColor: AppColors.light,
                              );
                            }
                          },
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
                      SizedBox(height: 5),
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
                              maxLength: 25,
                              keyboardType: TextInputType.name,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]')),
                              ],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Name',
                                counterText: '',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
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
                        height: 8,
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
                                width: 8,
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
                      SizedBox(height: 8),
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
                                          color: const Color.fromARGB(
                                              255, 108, 197, 199),
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
                              SizedBox(width: 8),
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[a-zA-Z]')),
                                        ],
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
                      SizedBox(height: 8),
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
                              maxLength: 35,
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
                                  counterText: ''),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                String fullName = _userNameController.text;
                                String email = _userEmailController.text;
                                String mobile = _userMobileController.text;
                                String city = _userCityController.text;
                                String dateOfBirth =
                                    _userDateOfBirthController.text;

                                _sharedPref.save(
                                    "KingUserProfileName", fullName);
                                _sharedPref.save("KingUserProfileEmail", email);
                                _sharedPref.save(
                                    "KingUserProfileMobile", mobile);
                                _sharedPref.save("KingUserProfileCity", city);
                                _sharedPref.save(
                                    "KingUserProfileDateOfBirth", dateOfBirth);

                                bool isConnected = await HttpRequestHelper
                                    .checkInternetConnection(context);
                                if (isConnected) {
                                  updateUserData();
                                  // getImei();
                                  //   inputData();
                                  Navigator.pop(context,
                                      {'name': fullName, 'email': email});
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: 18,
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
