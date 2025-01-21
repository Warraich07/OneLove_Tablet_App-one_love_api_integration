import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
class PushNotifications {
  static Future<String> getAccessTokens() async {
    final serviceAccountJson = {

    
    };

    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/userinfo.email',
    ];
    http.Client client = http.Client();
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

  static sendNotificationToSelectedDriver(String deviceToken) async {
    final String serverKeyAccessToken = await getAccessTokens();
    log(serverKeyAccessToken);

  }
}


// String endPointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/beauty-connect-9d187/messages:send';
// final Map<String, dynamic> message = {
//   'message': {
//     'token': deviceToken,
//     'notification': {
//       'title': 'title is',
//       'body': 'body is'
//     },
//     // 'data':
//     // {
//     //   'tripID': tripId
//     // }
//   }
// };
//
// final http.Response response = await http.post(
//   Uri.parse(endPointFirebaseCloudMessaging),
//   headers: <String, String>{
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $serverKeyAccessToken'
//   },
//   body: jsonEncode(message),
// );
//
// if (response.statusCode == 200) {
//   print("notification sent");
// } else {
//   print("notification not sent ${response.statusCode}");
// }
