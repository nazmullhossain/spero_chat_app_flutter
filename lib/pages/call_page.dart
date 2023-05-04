import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/controller/call_controller.dart';
import 'package:whatapp_clone/models/call_models.dart';
import 'package:whatapp_clone/widgets/loader_widgets.dart';

import '../config/agogra_config.dart';

class CallPage extends ConsumerStatefulWidget {
  const CallPage({Key? key,
  required this.callModel,
  required this.isGroupChat,
  required this.channelId}) : super(key: key);

  final String channelId;
  final CallModel callModel;
  final bool isGroupChat;

  @override
  ConsumerState<CallPage> createState() => _CallPageState();
}

class _CallPageState extends ConsumerState<CallPage> {
  AgoraClient? client;
  String baseUrl="http://localhost:8080";
@override
  void initState() {
    // TODO: implement initState
  super.initState();
  client=AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: AgoraConfig.appId,
          channelName: widget.channelId,
      tokenUrl: baseUrl));
  initAgora();

  }
  void initAgora()async{
  await client!.initialize();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client==null? LoaderWidget():
      SafeArea(child: Stack(
        children: [
          AgoraVideoViewer(client: client!),
          AgoraVideoButtons(client: client!,
            disconnectButtonChild: IconButton(onPressed: ()async{
await client!.engine.leaveChannel();
ref.read(callControllerProvider).endCall(widget.callModel.callerId, widget.callModel.reciverId, context);
Navigator.pop(context);

            }, icon: Icon(Icons.call_end,color: Colors.redAccent,)),)
        ],
      )),
    );
  }
}
