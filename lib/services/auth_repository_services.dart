import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/layout/mobile_layout.dart';
import 'package:whatapp_clone/models/user_models.dart';
import 'package:whatapp_clone/services/common_firebase_storage_services.dart';
import 'package:whatapp_clone/utils/utils_utils.dart';

import '../pages/otp_pages.dart';
import '../pages/user_information_page.dart';

final authRepositoryPrivider = Provider((ref) => AuthRepositoryServices(
    firesotre: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class AuthRepositoryServices {
  final FirebaseAuth auth;
  final FirebaseFirestore firesotre;

  AuthRepositoryServices({required this.firesotre, required this.auth});

  void singInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.pushNamed(context, OTPPage.routeName,
                arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOtp(
      {required BuildContext context,
      required String verificationId,
      required String userOtp}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationPage.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    String photoUrl = "assets/images/my.png";
    String uid = auth.currentUser!.uid;
    try {
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageServiceProvider)
            .storeFileToFirebase("profilePic/$uid", profilePic);
      }

      var user = UserModel(
          uid: uid,
          profilePic: photoUrl,
          name: name,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);
      await firesotre.collection("users").doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MobileLayout()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user;
    var userData =
        await firesotre.collection("users").doc(auth.currentUser?.uid).get();
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> userData(String userId) {
    return firesotre
        .collection("users")
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

void setUserState(bool isOnline)async{
    await firesotre.collection('users')
        .doc(auth.currentUser!.uid)
        .update({
"isOnline": isOnline,
    });
}


}
