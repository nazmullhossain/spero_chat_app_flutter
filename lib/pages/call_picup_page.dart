import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/controller/call_controller.dart';
import 'package:whatapp_clone/models/call_models.dart';

import 'call_page.dart';

class CallPickUpPage extends ConsumerWidget {
  const CallPickUpPage({Key? key,required this.scaffold}) : super(key: key);
  final Widget scaffold;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
        builder: (context,snapshot){
        if(snapshot.hasData && snapshot.data!.data()!=null){
         CallModel callModel=
             CallModel.fromMap(snapshot.data!.data()as Map<String,dynamic>);

         if(!callModel.hasDialled){
           return Scaffold(
             body: Container(
               alignment: Alignment.center,
               padding: EdgeInsets.symmetric(vertical: 20),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text("Icomming Call",style: TextStyle(
                     fontSize: 20,
                     color: Colors.white
                   ),),
                   SizedBox(height: 20,),

                   CircleAvatar(
                     backgroundImage: NetworkImage(callModel.callerPic),
                     radius: 50,
                   ),
                   SizedBox(height: 20,),
                   Text(callModel.callerName,style: TextStyle(
                       fontSize: 20,
                       color: Colors.white,
                     fontWeight: FontWeight.bold
                   ),),
                   SizedBox(height: 50,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       IconButton(onPressed: (){}, icon: Icon(Icons.call,
                       color: Colors.redAccent,)),
SizedBox(width: 25,),
                       IconButton(onPressed: (){
                         Navigator.push(context,MaterialPageRoute(builder: (context)=>CallPage(
                             callModel: callModel,
                             isGroupChat: false,
                             channelId: callModel.callId)));
                       }, icon: Icon(Icons.call_end,
                         color: Colors.green,)),

                     ],
                   )
                 ],
               ),
             ),
           );
         }

        }
        return scaffold;
        });
  }
}
