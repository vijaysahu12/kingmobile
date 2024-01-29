class ApiUrlConstants {
  //static String baseUrl = 'http://192.168.29.246:8083/api/';
  static String mainUrl = 'http://mobile.kingresearch.co.in/';
  // static String mainUrl = 'http://192.168.29.246:8083/';

  static String baseUrl = mainUrl + 'api/';
  static String pusherBeamAuthCode = 'b16893bd-70f8-4868-ba42-32e53e665741';
  static String login = baseUrl + "Account/login";
  static String getProducts = baseUrl + 'Product/GetProducts/';
  static String getProductById = baseUrl + 'Product/GetProductById';
  static String usersEndpoint = '/users';
  static String getPersonalDetails = '/getPersonalDetails';
  static String managePersonalDetails = "";
  static String otpLogin = baseUrl + "Account/otpLogin";
  static String otpLoginVerfication = baseUrl + "Account/otpLoginVerfication";
  static String LikeUnlikeProduct = baseUrl + "Product/LikeUnlikeProduct";
  static String GetNotifications =
      baseUrl + 'PushNotification/GetNotifications';
  static String MarkNotificationsIsRead =
      baseUrl + 'PushNotification/MarkNotificationAsRead';
  static String ManagePurchaseOrder = baseUrl + 'Payment/ManagePurchaseOrder';
  static String MyBucketContent = baseUrl + 'Product/MyBucketContent';
  static String GetSubscriptionTopics =
      baseUrl + 'Account/GetSubscriptionTopics';
  static String ManageUserDetails = baseUrl + 'Account/ManageUserDetails';
  static String GetUserDetails = baseUrl + 'Account/GetUserDetails';
  static String RateProduct = baseUrl + 'Product/RateProduct';
  static String GetTopGainers = baseUrl + 'Product/GetTopGainers';
}

class SessionConstants {
  static String Token = "KingUserToken";
  static String UserKey = "KingUserId";
  static String UserProfileImage = "KingUserProfileImage";
  static String OneTimePassword = "OneTimePassword";
  static String UserName = "KingUserName";
}
// class SessionConstants {
//   static String mobile = "mobileNumber";
//   // static String UserKey = "KingUserId";
//   // static String UserProfileImage = "KingUserProfileImage";
// }
