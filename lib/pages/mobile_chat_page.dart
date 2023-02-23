import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/controller/auth_controller.dart';
import 'package:whatapp_clone/models/user_models.dart';
import 'package:whatapp_clone/widgets/loader_widgets.dart';

import '../utils/color_utils.dart';
import '../widgets/bottom_chat_field_widget.dart';
import '../widgets/chat_list_widgets.dart';
import '../widgets/info_widget.dart';

class MobileChatPage extends ConsumerWidget {
   MobileChatPage({Key? key, required this.name, required this.uid})
      : super(key: key);
  static const String routeName = "/chat";
  final String name;
  final String uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authContorllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoaderWidget();
              }
              return Column(
                children: [
                  Text(
                    name,
                  ),
                  Text(
                    snapshot.data!.isOnline ? "online" : "offline",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  )
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
           Expanded(
            child: ChatListWidget(reciverUserId: uid,),
          ),
          BottomChatFieldWidget(
            recieverUserId: uid,
          )
        ],
      ),
    );
  }
}
