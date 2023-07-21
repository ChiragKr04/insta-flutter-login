import 'package:flutter/material.dart';
import 'package:insta_login_1/pages/instagram_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key, required this.token, required this.name})
      : super(key: key);
  final String token;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $name'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstagramView(),
                  ),
                  (route) => false,
                );
              })
        ],
      ),
      body: Center(
        child: Text('Token: $token'),
      ),
    );
  }
}
