import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatapp_clone/utils/color_utils.dart';
import 'package:whatapp_clone/utils/utils_utils.dart';

import '../controller/group_controller.dart';
import '../widgets/select_group_contact_widget.dart';

class GroupPage extends ConsumerStatefulWidget {
  const GroupPage({Key? key}) : super(key: key);
static const String routeName='/group';

  @override
  ConsumerState<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends ConsumerState<GroupPage> {

  File?image;
TextEditingController groupController=TextEditingController();

@override
  void dispose() {
    // TODO: implement dispose
  groupController.dispose();
    super.dispose();
  }


  void selectImage()async{
    image=await pickImageFromGallery(context);
    setState(() {

    });
  }
  void createGroup(){
  if(groupController.text.trim().isNotEmpty && image!= null){
ref.read(groupControllerProvider).createGroup(context, groupController.text.trim(), image!, ref.read(selectedGroupContact));
ref.read(selectedGroupContact.state).update((state) => []);
 Navigator.pop(context);
  }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group"),
      ),
      body: Column(
        children: [
SizedBox(height: 10,),


          Stack(
            children: [
              image==null?
              const CircleAvatar(

                  radius: 50,
                  backgroundImage: AssetImage("assets/images/my.png")
                // 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"),
              ) :
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(image!),
              )
              ,
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                      onPressed: () {
                        selectImage();
                      }, icon: const Icon(Icons.add_a_photo)))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: groupController,
              decoration: InputDecoration(
                hintText: "Enter Group Name"
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text("Select Contact",style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),),
          ),
          SelectConactsGroupWidget()
        ],
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        onPressed: (){
          createGroup();
        },
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),

      ),
    );
  }
}
