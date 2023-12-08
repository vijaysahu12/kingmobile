class ApiUrlConstants {
  static String baseUrl = 'http://192.168.29.246:8083/api/';
  static String login = baseUrl + "Account/login";
  static String getProducts = baseUrl + 'Product/GetProducts';
  static String getProductById = baseUrl + 'Product/GetProductById';
  static String usersEndpoint = '/users';
  static String getPersonalDetails = '/getPersonalDetails';
  static String managePersonalDetails = "";
  static String otpLogin = baseUrl + "Account/otpLogin";
  static String otpLoginVerfication = baseUrl + "Account/otpLoginVerfication";
}

class SessionConstants {
  static String Token = "KingUserToken";
  static String UserKey = "KingUserId";
  static String UserProfileImage = "KingUserProfileImage";
  static String UserName = "KingUserName";
}
// class SessionConstants {
//   static String mobile = "mobileNumber";
//   // static String UserKey = "KingUserId";
//   // static String UserProfileImage = "KingUserProfileImage";
// }
