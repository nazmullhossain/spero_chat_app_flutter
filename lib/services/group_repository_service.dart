import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatapp_clone/services/common_firebase_storage_services.dart';
import 'package:whatapp_clone/utils/utils_utils.dart';

import '../models/group_model.dart' as model;

final groupRepositoryProvider = Provider((ref) => GroupRepositoryService(
    firestore: FirebaseFirestore.instance,
    ref: ref,
    auth: FirebaseAuth.instance));

class GroupRepositoryService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepositoryService(
      {required this.firestore, required this.ref, required this.auth});

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContact) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo:
                    selectedContact[i].phones[0].number.replaceAll(" ", ''))
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();

      String profileurl = await ref
          .read(commonFirebaseStorageServiceProvider)
          .storeFileToFirebase(
            'group/$groupId',
            profilePic,
          );
      // String profileUrl = await ref
      //     .read(commonFirebaseStorageServiceProvider)
      //     .storeFileToFirebase(
      //   'group/$groupId',
      //   profilePic,
      // );

      model.GroupModel groupModel = model.GroupModel(
          groupId: groupId,
          name: name,
          senderId: auth.currentUser!.uid,
          lastMessage: "",
          groupPic: profileurl,
          timeSent: DateTime.now(),
          membersUid: [auth.currentUser!.uid, ...uids]);

      await firestore.collection('groups').doc(groupId).set(groupModel.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
