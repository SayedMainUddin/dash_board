class Notice {
  final String? noticeId;
  final String? noticeTitle;
  final String? noticeDescription;
  final String? creatorId;
  final DateTime? creatingDate;
  final DateTime? noticeDeadLine;

  Notice({
     this.noticeId,
     this.noticeTitle,
     this.noticeDescription,
     this.creatorId,
     this.creatingDate,
     this.noticeDeadLine,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json['_id'] ?? '',
      noticeTitle: json['NoticeTitle'] ?? '',
      noticeDescription: json['NoticeDescription'] ?? '',
      creatorId: json['CreatorId'] ?? '',
      creatingDate: DateTime.parse(json['CreatingDate'] ?? ''),
      noticeDeadLine: DateTime.parse(json['NoticeDeadLine'] ?? ''),
    );
  }
}
