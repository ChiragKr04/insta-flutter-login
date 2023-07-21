import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:insta_login_1/constants/instagram_constant.dart';
import 'package:insta_login_1/repository/firebase_repository.dart';
import 'package:insta_login_1/repository/instagram_repository.dart';
import 'package:insta_login_1/pages/home.dart';

class InstagramView extends StatefulWidget {
  const InstagramView({Key? key}) : super(key: key);

  @override
  State<InstagramView> createState() => _InstagramViewState();
}

class _InstagramViewState extends State<InstagramView> {
  late FlutterWebviewPlugin webview;
  late InstagramRepository instagram;
  final FirebaseRepository firebaseRepository = FirebaseRepository();

  @override
  void initState() {
    super.initState();
    webview = FlutterWebviewPlugin();
    instagram = InstagramRepository();
    listenOnUrlChange();
  }

  void listenOnUrlChange() {
    webview.onUrlChanged.listen((String url) async {
      if (url.contains(InstagramConstant.redirectUri)) {
        instagram.getAuthorizationCode(url);
        await instagram.getTokenAndUserID().then((isDone) {
          if (isDone) {
            instagram.getUserProfile().then((isDone) async {
              await webview.close();

              log('${instagram.username} logged in!');

              await firebaseRepository.saveTokenToFb({
                'username': instagram.username,
                'token': instagram.accessToken,
                'profile': instagram.instaProfile,
              });

              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomeView(
                    token: instagram.accessToken.toString(),
                    name: instagram.username.toString(),
                  ),
                ),
              );
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return WebviewScaffold(
        url: InstagramConstant.url,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Instagram Login',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.black),
          ),
        ),
      );
    });
  }
}
