class InstagramConstant {
  static const String clientID = '982089966368806';
  static const String appSecret = '1313d7df7728c593bb115f0b358cf699';
  static const String redirectUri = 'https://github.com/chiragKr04';
  static const String scope = 'user_profile,user_media';
  static const String responseType = 'code';
  static const String url =
      'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=$scope&response_type=$responseType';
}
