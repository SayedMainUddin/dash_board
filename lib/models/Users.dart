class User {
  final String? userId;
  final String? userName;
  final String? userDepartment;
  final String? address;
  final String? password;
  final String? userImageUrl;
  final String? lastMsg;
  final String? lastChat;
  final String? lastMsgTime;
  final bool? isGroup;
  final String? uniqueId;
  final String? Type;
  final String? RequestStatus;
  final String? BlockStatus;
  final String? MuteStatus;
  final String? status;
  final String? time;
  final String? currentMessage;
   bool? isOnline;
  final String? notificationCount;
  final String? notificationStatus;
  final String? forwardCount;
  final String? deletedForever;
  final String? gender;
  final String? email;
  final String? dob;
  final String? mobile;
  final String? seenStatus;
  final String? blockedBy;
  final String? senderId;
  final String? privacy;
  final List? StoryList;
  final String? admin;
  bool isSelected;
  final int? id;
  User({
    this.userId,
    this.userName,
    this.userDepartment,
    this.address,
    this.password,
    this.userImageUrl,
    this.lastMsg,
    this.uniqueId,
    this.Type,
    this.RequestStatus,
    this.time,
    this.currentMessage,
    this.BlockStatus,
    this.MuteStatus,
    this.status,
    this.isGroup,
    this.isOnline,
    this.admin,
    this.lastMsgTime,
    this.notificationCount,
    this.notificationStatus,
    this.forwardCount,
    this.StoryList,
    this.lastChat,
    this.deletedForever,
    this.gender,
    this.email,
    this.dob,
    this.mobile,
    this.seenStatus,
    this.blockedBy,
    this.senderId,
    this.privacy,
    this.isSelected=false,
    this.id
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      userName: json['userName'],
      userDepartment: json['userDepartment'],
      address: json['address'],
      password: json['password'],
      userImageUrl: json['userImageUrl'],
      uniqueId: json['uniqueId'],
      Type: json['Type'],
      time: json['time'],
      StoryList: json['StoryList'],
      status: json['status'],
      senderId: json['senderId'],
      seenStatus: json['seenStatus'],
      RequestStatus: json['RequestStatus'],
      privacy: json['privacy'],
      notificationStatus: json['notificationStatus'],
      notificationCount: json['notificationCount'],
      MuteStatus: json['MuteStatus'],
      mobile: json['mobile'],
      lastMsgTime: json['lastMsgTime'],
      lastMsg: json['lastMsg'],
      lastChat: json['lastChat'],
      admin: json['admin'],
      blockedBy: json['blockedBy'],
      BlockStatus: json['BlockStatus'],
      currentMessage: json['currentMessage'],
      deletedForever: json['deletedForever'],
      dob: json['dob'],
      email: json['email'],
      forwardCount: json['forwardCount'],
      gender: json['gender'],
      isGroup: json['isGroup'],
      isOnline: json['isOnline'] == true,


    );
  }
}
