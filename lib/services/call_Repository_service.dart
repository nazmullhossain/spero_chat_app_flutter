import 'dart:io';
// import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatapp_clone/models/call_models.dart';
import 'package:whatapp_clone/pages/call_page.dart';
import 'package:whatapp_clone/services/common_firebase_storage_services.dart';
import 'package:whatapp_clone/utils/utils_utils.dart';

import '../models/group_model.dart' as model;

final callRepositoryProvider = Provider((ref) => CallRepositoryService(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class CallRepositoryService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  // final ProviderRef ref;

  CallRepositoryService({required this.firestore, required this.auth});


Stream<DocumentSnapshot>get callStream=>
    firestore.collection('call').doc(auth.currentUser!.uid).snapshots();



  void makeCall(CallModel senderCallData,
      BuildContext context ,CallModel reciverCallData) async {
    try {
   await firestore.collection("call").doc(senderCallData.callerId).set(senderCallData.toMap());
   await firestore.collection("call").doc(reciverCallData.reciverId).set(reciverCallData.toMap());

Navigator.push(context,MaterialPageRoute(builder: (context)=>CallPage(
    callModel: senderCallData,
    isGroupChat: false,
    channelId: senderCallData.callId)));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }




  void endCall(String callerId,
      BuildContext context ,String reciverId) async {
    try {
      await firestore.collection("call").doc(callerId).delete();
      await firestore.collection("call").doc(reciverId).delete();


    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
