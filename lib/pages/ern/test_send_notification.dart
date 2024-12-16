import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:geolocator/geolocator.dart';

class PushNotificationService extends StatelessWidget {
  static Future<String> getAccessToken() async {
    final serviceAccountJson =
    {
      "type": "service_account",
      "project_id": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "private_key_id": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "private_key": "-----BEGIN PRIVATE KEY-----\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n-----END PRIVATE KEY-----\n",
      "client_email": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "client_id": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }


  Future<void> sendNotification(String driverCondition, Position position, String username, String timestamp, String driverId) async {
      final String serverAccessTokenkey = await getAccessToken();
      String endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/messages:send';

      // Reactjs web app dashboard fcm token
      final String deviceToken = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

      final Map<String, dynamic> message = {
        'message': {
          'token': deviceToken,
          'notification': {
            'title': "Notification Testing",
            'body': driverCondition
          },
          'data': {
            'latitude' : position.latitude.toString(),
            'longitude' : position.longitude.toString(),
            'username' : username,
            'timestamp': timestamp,
            'driverId' : driverId
          }
        }
      };

      final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String>
        {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenkey'
        },
        body: jsonEncode(message)
        ,);

      if (response.statusCode == 200) {
        print("Notification sent successfully");
      }
      else {
        print("Notification sent: ${response.statusCode}");
      }
    }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FCM Notification Test'),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () async{
                //await sendNotification(context);
              },
                child: Text('Send Notification'),
              ),
        ),
      ),
    );
  }
  }