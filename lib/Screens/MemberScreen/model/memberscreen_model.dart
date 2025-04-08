class ExerciseModel {
  final String id;
  final String exerciseTitle;
  final String exerciseDesc;
  final DateTime createdAt;

  ExerciseModel({
    required this.id,
    required this.exerciseTitle,
    required this.exerciseDesc,
    required this.createdAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id']?.toString() ?? '',
      exerciseTitle: json['exercise_title'] ?? '',
      exerciseDesc: json['exercise_desc'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class NoticeModel {
  final String id;
  final String noticeTitle;
  final String noticeDesc;
  final DateTime createdAt;

  NoticeModel({
    required this.id,
    required this.noticeTitle,
    required this.noticeDesc,
    required this.createdAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id']?.toString() ?? '',
      noticeTitle: json['notice_title'] ?? '',
      noticeDesc: json['notice_desc'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class UpiModel {
  final String id;
  final String upiId;
  final String amount;
  final DateTime createdAt;

  UpiModel({
    required this.id,
    required this.upiId,
    required this.amount,
    required this.createdAt,
  });

  factory UpiModel.fromJson(Map<String, dynamic> json) {
    return UpiModel(
      id: json['id']?.toString() ?? '',
      upiId: json['upi_id'] ?? '',
      amount: json['amount'] ?? '0.0',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
