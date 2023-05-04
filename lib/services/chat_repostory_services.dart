import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatapp_clone/enums/message_enum.dart';
import 'package:whatapp_clone/models/chat_contact_models.dart';
import 'package:whatapp_clone/models/message_models.dart';
import 'package:whatapp_clone/models/user_models.dart';
import 'package:whatapp_clone/provider/message_reply_provider.dart';
import 'package:whatapp_clone/services/common_firebase_storage_services.dart';
import 'package:whatapp_clone/utils/utils_utils.dart';
import 'package:whatapp_clone/widgets/info_widget.dart';

import '../models/group_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contact = [];

      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());

        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();

        var user = UserModel.fromMap(userData.data()!);

        contact.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));

        print('hellow ${contact![0]}');
      }
      return contact;
    });
  }

  Stream<List<GroupModel>> getChatGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<GroupModel> groups = [];

      for (var document in event.docs) {
        var group = GroupModel.fromMap(document.data());

        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<Message>> getChatStream(String reciverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .asyncMap((event) {
      List<Message> message = [];
      for (var document in event.docs) {
        message.add(Message.fromMap(document.data()));
      }
      return message;
    });
  }

  Stream<List<Message>> getGroupStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('groups')
        .orderBy('timeSent')
        .snapshots()
        .asyncMap((event) {
      List<Message> message = [];
      for (var document in event.docs) {
        message.add(Message.fromMap(document.data()));
      }
      return message;
    });
  }

  void _saveDataToContactsSubcollection(
      UserModel senderUserData,
      UserModel? recieverUserData,
      String text,
      DateTime timeSent,
      String recieverUserId,
      bool isGroupChat) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverUserId).update({
        "lastMessage": text,
        "timeSent": DateTime.now().millisecondsSinceEpoch
      });
    } else {
      // users -> reciever user id => chats -> current user id -> set data
      var recieverChatContact = ChatContact(
        timeSent: timeSent,
        lastMessage: text,
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
      );
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(
            recieverChatContact.toMap(),
          );
      print("_saveDataToContactsSubcollection");
      // users -> current user id  => chats -> reciever user id -> set data
      var senderChatContact = ChatContact(
        name: recieverUserData!.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(
             senderChatContact.toMap(),
          );
    }
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required String senderUsername,
    // required String? recieverUserName,
    required MessageReply? messageReply,
    required String? reciverUserName,
    required bool isGroupChat,
  }) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        recieverid: recieverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedMessage: messageReply == null ? "" : messageReply.message,
        repliedTo: messageReply == null
            ? ""
            : messageReply.isMe
                ? senderUsername
                : reciverUserName ?? '',
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum);

    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
      // users -> eciever id  -> sender id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    }
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required UserModel senderUser,
      required MessageReply? messageReply,
      required bool isGroupChat}) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(senderUser, recieverUserData, text,
          timeSent, recieverUserId, isGroupChat);

      _saveMessageToMessageSubcollection(
          text: text,
          timeSent: timeSent,
          messageType: MessageEnum.text,
          messageId: messageId,
          reciverUserName: recieverUserData!.name,
          username: senderUser.name,
          senderUsername: senderUser.name,
          messageReply: messageReply,
          recieverUserId: recieverUserId,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    print('chat reposity');
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required reciverUserId,
      required UserModel senderUserData,
      required ProviderRef ref,
      required MessageEnum messageEnum,
      required MessageReply? messageReply,
      required bool isGroupchat}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageServiceProvider)
          .storeFileToFirebase(
              "chat/${messageEnum.type}/${senderUserData.uid}/$reciverUserId/$messageId",
              file);

      UserModel? recieverUserData;
      if (!isGroupchat) {
        var userDataMap =
            await firestore.collection('users').doc(reciverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = 'Photo';
          break;

        case MessageEnum.video:
          contactMsg = 'Video';
          break;

        case MessageEnum.audio:
          contactMsg = 'audio';
          break;

        case MessageEnum.gif:
          contactMsg = 'Gif';
          break;

        default:
          contactMsg = 'Gif';
      }

      _saveDataToContactsSubcollection(
        // senderUserData,
        // recieverUserData,
        //
        // contactMsg,
        // timeSent,
        // reciverUserId

        senderUserData,
        recieverUserData,
        contactMsg,
        timeSent,
        reciverUserId,
        isGroupchat,
      );

      _saveMessageToMessageSubcollection(
          recieverUserId: reciverUserId,
          text: imageUrl,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUserData.name,
          messageType: messageEnum,
          senderUsername: senderUserData.name,
          reciverUserName: recieverUserData?.name,
          isGroupChat: isGroupchat,
          messageReply: messageReply);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  // void sendGIFMessage({
  //   required BuildContext context,
  //   required String gifUrl,
  //   required String recieverUserId,
  //   required UserModel senderUser,
  // }) async {
  //   try {
  //     var timeSent = DateTime.now();
  //     UserModel? recieverUserData;
  //
  //     var userDataMap =
  //     await firestore.collection('users').doc(recieverUserId).get();
  //     recieverUserData = UserModel.fromMap(userDataMap.data()!);
  //
  //     var messageId = const Uuid().v1();
  //
  //     _saveDataToContactsSubcollection(
  //       senderUser,
  //       recieverUserData,
  //       "GIF",
  //       timeSent,
  //       recieverUserId,
  //     );
  //
  //     _saveMessageToMessageSubcollection(
  //       recieverUserId: recieverUserId,
  //       text: gifUrl,
  //       timeSent: timeSent,
  //       messageType: MessageEnum.gif,
  //       messageId: messageId,
  //       recieverUserName: recieverUserData?.name,
  //       username: senderUser.name,
  //       senderUsername: senderUser.name,
  //     );
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  //   print('chat reposity');
  // }
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //

  void setChatMessageSeen(
      BuildContext context, String reciverUserId, String messageId) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(reciverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      firestore
          .collection('users')
          .doc(reciverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
