class Notice {
  final String? noticeId;
  final String? noticeTitle;
  final String? noticeDescription;
  final String? creatorId;
  final DateTime? creatingDate;
  final DateTime? noticeDeadLine;
  final List<SeenUser>? seenUsers;

  Notice({
    this.noticeId,
    this.noticeTitle,
    this.noticeDescription,
    this.creatorId,
    this.creatingDate,
    this.noticeDeadLine,
    this.seenUsers,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json['_id'] ?? '',
      noticeTitle: json['NoticeTitle'] ?? '',
      noticeDescription: json['NoticeDescription'] ?? '',
      creatorId: json['CreatorId'] ?? '',
      creatingDate: DateTime.parse(json['CreatingDate'] ?? ''),
      noticeDeadLine: DateTime.parse(json['NoticeDeadLine'] ?? ''),
      seenUsers: json['SeenUsers'] != null
          ? List<SeenUser>.from(
          json['SeenUsers'].map((x) => SeenUser.fromJson(x)))
          : [], // Parse seenUsers if available
    );
  }
}


class SeenUser {
  final String userId;
  final bool seen;

  SeenUser({
    required this.userId,
    required this.seen,
  });

  factory SeenUser.fromJson(Map<String, dynamic> json) {
    return SeenUser(
      userId: json['userId'] ?? '',
      seen: json['seen'] ?? false,
    );
  }
}

