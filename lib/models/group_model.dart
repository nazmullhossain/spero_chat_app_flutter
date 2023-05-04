class GroupModel{
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final DateTime timeSent;

final String groupPic;
  final List<String>membersUid;


  GroupModel({
    required this.groupId,
    required this.name,

    required this.senderId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.timeSent


});

 factory GroupModel.fromMap(Map<String, dynamic> map){
 return GroupModel(
     senderId : map['senderId'] ?? '',
     name : map['name'] ?? '',
     groupId : map['groupId'] ?? '',
     lastMessage : map['lastMessage']?? '',
     timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
     groupPic : map['groupPic']?? '',
     membersUid : List<String>.from(map['membersUid'])
 );
 }


  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'name': name,
        'groupId': groupId,
        'lastMessage': lastMessage,
    'timeSent': timeSent.millisecondsSinceEpoch,
        'groupPic': groupPic,
        'membersUid': membersUid,
      };
}