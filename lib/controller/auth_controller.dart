import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_models.dart';
import '../services/auth_repository_services.dart';
import '../services/auth_repository_services.dart';

final authContorllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryPrivider);
  return AuthContorller(authRepositoryServices: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authContorller = ref.watch(authContorllerProvider);
  return authContorller.getUserData();
});

class AuthContorller {
  final ProviderRef ref;
  final AuthRepositoryServices authRepositoryServices;

  AuthContorller({required this.authRepositoryServices, required this.ref});

  void signInWithPhone(BuildContext context, String phonenumber) {
    authRepositoryServices.singInWithPhone(context, phonenumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepositoryServices.verifyOtp(
        context: context, verificationId: verificationId, userOtp: userOTP);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File profilePic) {
    authRepositoryServices.saveUserDataToFirebase(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepositoryServices.getCurrentUserData();
    return user;
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepositoryServices.userData(userId);
  }
}
