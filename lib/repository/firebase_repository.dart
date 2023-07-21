import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepository {
  Future<void> saveTokenToFb(Map<String, dynamic> userData) async {
    CollectionReference<Map<String, dynamic>> usersTokenCollection =
        FirebaseFirestore.instance.collection('userTokens');
    String userId = userData["userName"];
    DocumentReference<Map<String, dynamic>> usersData =
        usersTokenCollection.doc(userId);

    await usersData.set(userData).whenComplete(() {
      log("User Token saved to Firebase");
    }).catchError((e) {
      log(e);
    });
  }
}
