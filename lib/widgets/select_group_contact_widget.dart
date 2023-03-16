import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/controller/select_contact_controller.dart';
import 'package:whatapp_clone/widgets/loader_widgets.dart';

import 'error_widgets.dart';




final selectedGroupContact=
StateProvider<List<Contact>>((ref) => []);




class SelectConactsGroupWidget extends ConsumerStatefulWidget {
  const SelectConactsGroupWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectConactsGroupWidget> createState() => _SelectConactsGroupWidgetState();
}

class _SelectConactsGroupWidgetState extends ConsumerState<SelectConactsGroupWidget> {
 List<int>selectedContactsIndex=[];




 void selectContact(int index,Contact contact){
   if(selectedContactsIndex.contains(index)){
     selectedContactsIndex.removeAt(index);
   }else{
     selectedContactsIndex.add(index);
   }
   setState(() {

   });
   ref.read(selectedGroupContact.state)
   .update((state) => [...state,contact]);
 }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider)
        .when(
        data: (contactList)=>Expanded(
            child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context,index){
                  final contact=contactList[index];
                  return InkWell(
                    onTap: (){
                      selectContact(index,contact);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8),

                      child: ListTile(
                        title: Text(contact.displayName,
                          style: TextStyle(fontSize: 18),),



                        leading: selectedContactsIndex.contains(index)
                        ?IconButton(onPressed: (){}, icon: Icon(Icons.done)):
                      null,
                      ),
                    ),
                  );
                })),
        error: (err,trace)=>ErrorWidgets(error: err.toString(),),
        loading: ()=>LoaderWidget());
  }
}
