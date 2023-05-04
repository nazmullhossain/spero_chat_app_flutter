import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatapp_clone/controller/auth_controller.dart';
import 'package:whatapp_clone/models/call_models.dart';
import 'package:whatapp_clone/services/chat_repostory_services.dart';

import '../services/call_Repository_service.dart';
import '../services/group_repository_service.dart';

final callControllerProvider=Provider((ref) {
  final callRepository=ref.read(callRepositoryProvider);
  return CallController(callRepository: callRepository,
      auth: FirebaseAuth.instance,
      ref: ref);
});


class CallController{
  final CallRepositoryService  callRepository;
  final ProviderRef ref;
final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth
  });

Stream <DocumentSnapshot>get callStream=>callRepository.callStream;
  void makeCall(BuildContext context,
      String reciverName,String receverUid,String reciverProfilePic,bool isgroupChat){
    String callId=const Uuid().v1();
    
    ref.read(userDataAuthProvider).whenData((value) {

      CallModel senderCallData=CallModel(
    callerId: auth.currentUser!.uid,
    callerName: value!.name
    , callerPic: value.profilePic,
    reciverId: receverUid,
    reciverName: reciverName,
    receiverPic: reciverProfilePic,
    callId: callId,
    hasDialled: true);


      CallModel reciverCallData=CallModel(
          callerId: auth.currentUser!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          reciverId: receverUid,
          reciverName: reciverName,
          receiverPic: reciverProfilePic,
          callId: callId,
          hasDialled: false);
      callRepository.makeCall(senderCallData, context, reciverCallData);

    });
    

    
  }


  void endCall(
      String callerId,
      String reciverId,
      BuildContext context,
      ){
    callRepository.endCall(callerId, context, reciverId);
  }
}

