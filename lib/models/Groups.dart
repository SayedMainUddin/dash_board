class Group {
  String id;
  String groupName;
  List<dynamic> membersID;
  String adminID;
  String groupPic;
  String privacy;
  String dateTime;
  bool isSelected;


  Group({
    required this.id,
    required this.groupName,
    required this.membersID,
    required this.adminID,
    required this.groupPic,
    required this.privacy,
    required this.dateTime,
     this.isSelected=false,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'] as String,
      groupName: json['GroupName'] as String,
      membersID: (json['MembersID'] as List).map((e) => e as String).toList(),
      adminID: json['Admin'] as String,
      groupPic: json['GroupPic'] as String,
      privacy: json['Privacy'] as String,
      dateTime: json['DateTime'] as String,

    );
  }
}
