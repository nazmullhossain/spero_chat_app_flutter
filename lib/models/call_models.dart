class CallModel {
  final String callerId;

  final String callerName;
  final String callerPic;
  final String reciverId;
  final String reciverName;
  final String receiverPic;
  final String callId;
  final bool hasDialled;

  CallModel(
      {
        required this.callerId,
        required  this.callerName,
        required this.callerPic,
        required this.reciverId,
        required  this.reciverName,
        required  this.receiverPic,
        required  this.callId,
        required this.hasDialled});


  Map<String,dynamic>toMap(){
    return{
      "callerId":callerId,
      "callerName":callerName,
      "callerPic":callerPic,
      "reciverId":reciverId,
      "reciverName":reciverName,
      "receiverPic":receiverPic,
      "callId":callId,
      "hasDialled":hasDialled,

    };
  }
factory CallModel.fromMap(Map<String,dynamic>map){
    return CallModel(
        callerId: map["callerId"] ?? '',
        callerName: map["callerName"] ?? '',
        callerPic: map["callerPic"] ?? '',
        reciverId: map["reciverId"] ?? '',
        reciverName:map ["reciverName"] ?? '',
        receiverPic: map["receiverPic"] ?? '',
        callId:map ["callId"] ?? '',
        hasDialled: map["hasDialled"]  ?? false);
}



}
