import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/controller/auth_controller.dart';
import 'package:whatapp_clone/utils/utils_utils.dart';

import '../pages/confirm_page.dart';
import '../pages/group_page.dart';
import '../pages/select_contact_pages.dart';
import '../pages/status_pages.dart';
import '../utils/color_utils.dart';
import '../widgets/contact_list_widget.dart';


class MobileLayout extends ConsumerStatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<MobileLayout>
with WidgetsBindingObserver, TickerProviderStateMixin{
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController=TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        ref.read(authContorllerProvider).setUserState(true);
        break;


      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authContorllerProvider).setUserState(false);
        break;

    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
          PopupMenuButton(
             icon: Icon(Icons.more_vert,color: Colors.grey,),
              itemBuilder: (context)=>[
            PopupMenuItem(child: Text("Create Group")
            ,onTap: ()=>
           Future(()=>   Navigator.pushNamed(context, GroupPage.routeName))

            )
          ])
          ],
          bottom:  TabBar(
            controller: tabController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController ,
           children: const [
             ContactsListWidget(),
             StatusPages(),
             Text("Calls")
           ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            if(tabController.index==0){
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            }else{
              File?pickImage=await pickImageFromGallery(context);
              if(pickImage!=null){
                Navigator.pushNamed(context, ConfirmStatusPage.routeName,arguments: pickImage);
              }
            }

          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}