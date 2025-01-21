import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
class PushNotifications {
  static Future<String> getAccessTokens() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "one-love-b4c55",
      "private_key_id": "5534c2e89ff7e936c6fd14a6f90a007943470cc2",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC+GlvKvt3uLmWt\no4HuZwEUfsNNnWdSELZ7C3CE2nWvXI98Fbeqm/UUratXQTSHKf8mwLRGkTjNV6SN\n0QPwTTzrC6DPnVWs+nkXq1ic6VJCk+2gKdcLhjrJyUyvsTLx3SnFEdhpCni+lWBU\njGoHwaeFOHP93s9pNDEzMx209PY7YJ83HCmsSJUV+CeLdYVsTPke9wLFyh9vIXBc\nKl8VJoh1wYeP0cg7weJOGEwzqa6K0wZU+N5Ahly73+pEWsu8T1KHcpNueEGY9X9x\nMgxEZFQMnzRn2zrGzO1bgDg3LDoUJjbor3aJnaETW4kQ8VbCQAzuuK0drGXFVxwj\ni6KMEY0PAgMBAAECggEAG4kMhqoYJz8dMdt0dH2tpbRUFv1CUUa5HSAjuiU9Kpte\nRSY4JkQqFEaw12tLGnuLc6eHSo66YDPeUpRV3QwIU4X+/ajXwhMS+x9chHiJ67mA\nOn9qS0cJY4pUIJaqvxG+fRxVRlG3+j2qEv+2U/f0NdMJf1ozR2psk0fyI5s1F0Bq\nuHZYMgSErF1MoTQLgE+Qla17Bi/qfsTnvQg7REtqUaYdXHBeJ71cPlcgf1WEj6o/\nSfiHtna7yONHNcb75fT8uky2icJe4DIYnCz7MJNDJ18Dw2w7V0fCrWQ821azNWSt\nyr+tQ1JtStpU2esRyTUNnE5HzB231hBpMwIsj+KUkQKBgQDxpIjhdJC/cn82EUvA\nH8MgIE+6gMAF0y6sWi5PQ8tN79CSZD4g2RujJYxKYxKYKWQmE8S6P/8OjNql+Jt/\nD92svRX6+EJOY9KZsGJUf3Q6PR2/2xZexoP17M/ZGgHEUDJi2R0ktPMbMhmXI/SP\njWVvalC+hSBPY+BZ5GokjNYNswKBgQDJZeMk5cT+jW5hgelscC384gLv7k1phj8A\nATHBob+EBxturIcpGXPsrgU7xBgyKXF+PxZJUTSPcFzf8h4lePJgEeoVgm4G19YN\naDR4WiG2LEooancwOhfU5mcsVdQ4D0lgHPGyYsdhXc6MEbPGNc1cYR3WsP5TcUvq\nze9uzabtNQKBgQDrOiT5fBRwGZBWXK3l38V935ZdUnoa8YIsyzjrdm5RdxMNfsGw\nDkjGH4Ya36i5MQnJu1K1kBjE3D74dDNClHpRblwYTFWXo7reW4LNCKlnDBmKq0Zy\nikLpQlbu208/AGacLQgetHs3TST2KU0n9Rf6Rn9Fh6h1QB+kwiLFY8f32wKBgQCs\nUu3ESIYCeOmVrR8ZlfMDii+RNIowXJnTWzJDyC6ivaIPVLhhxlGWlmAL/4Hkiel+\naGSdX0pl4XLWe8inr5FT+oAc33ldiZix6BPdVuG5irP5WP+a2FpD5NEq8lWfkhTq\nlFmKlVKcUTPGTe9RDgAlp0NszA0RQMQAqSzR1k2acQKBgQDrb6gkGSG92LkOhzLR\nqPYDLyKMUGS1uze1daNwzrKwHrYHK2FMrs0zcMEWlXWzXIygXm+DWKi2My/MEl7d\n4pcIj6hzs+8odCtbo5IniFeiQgCv7a15LkKuifDQywGvxfXvg/Y4e8AGSs6r9K58\nzmsbg5cc9k5ZH1kKK75/+NVuoA==\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-wp4fb@one-love-b4c55.iam.gserviceaccount.com",
      "client_id": "118055048522456155179",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-wp4fb%40one-love-b4c55.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
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