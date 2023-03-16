import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/group_repository_service.dart';

final groupControllerProvider=Provider((ref) {
final groupRepository=ref.read(groupRepositoryProvider);
return GroupController(groupRepositoryService: groupRepository, ref: ref);
});


class GroupController{
  final GroupRepositoryService  groupRepositoryService;
  final ProviderRef ref;

  GroupController({
    required this.groupRepositoryService,
    required this.ref
});


void createGroup(BuildContext context,
    String name,File profilePic,List<Contact> selectedContact){
  groupRepositoryService.createGroup(context, name, profilePic, selectedContact);
}
}

