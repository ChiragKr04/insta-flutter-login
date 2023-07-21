import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:insta_login_1/constants/instagram_constant.dart';

class InstagramRepository {
  List<String> userFields = ['id', 'username'];

  String? authorizationCode;
  String? accessToken;
  String? userID;
  String? username;
  Map<String, dynamic>? instaProfile;

  void getAuthorizationCode(String url) {
    authorizationCode = url
        .replaceAll('${InstagramConstant.redirectUri}?code=', '')
        .replaceAll('#_', '');
  }

  Future<bool> getTokenAndUserID() async {
    var url = Uri.parse('https://api.instagram.com/oauth/access_token');
    final response = await http.post(url, body: {
      'client_id': InstagramConstant.clientID,
      'redirect_uri': InstagramConstant.redirectUri,
      'client_secret': InstagramConstant.appSecret,
      'code': authorizationCode,
      'grant_type': 'authorization_code'
    });
    var token = json.decode(response.body)['access_token'];
    if (token != null) {
      accessToken = token.toString();
    }
    log("access Token: $accessToken");
    userID = json.decode(response.body)['user_id'].toString();
    return (accessToken != null && userID != null) ? true : false;
  }

  Future<bool> getUserProfile() async {
    final fields = userFields.join(',');
    final responseNode = await http.get(Uri.parse(
        'https://graph.instagram.com/$userID?fields=$fields&access_token=$accessToken'));
    instaProfile = {
      'id': json.decode(responseNode.body)['id'].toString(),
      'username': json.decode(responseNode.body)['username'],
    };
    var userName = json.decode(responseNode.body)['username'];
    if (userName != null) {
      username = userName.toString();
    }
    log('username: $username');
    return instaProfile != null && instaProfile!.isNotEmpty ? true : false;
  }
}
