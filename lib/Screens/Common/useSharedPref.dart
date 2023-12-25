import '../../Helpers/ApiUrls.dart';
import '../../Helpers/sharedPref.dart';

class UsingSharedPref {
  Future<String> getJwtToken() async {
    SharedPref _sharedPref = SharedPref();
    final String jsonWebToken = await _sharedPref.read(SessionConstants.Token);
    final jwt = jsonWebToken.replaceAll('"', '');
    return jwt;
  }
}

class UsingHeaders {
  Map<String, String> createHeaders(
      {required String jwtToken, String? contentType}) {
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': contentType ?? 'application/json',
    };
    return headers;
  }
}
