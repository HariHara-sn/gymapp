class ExerciseModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  ExerciseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id']?.toString() ?? '',
      title: json['exercise_title'] ?? '',
      description: json['exercise_desc'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise_title': title,
      'exercise_desc': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class NoticeModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id']?.toString() ?? '',
      title: json['notice_title'] ?? '',
      description: json['notice_desc'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notice_title': title,
      'notice_desc': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PaymentModel {
  final String id;
  final String upiId;
  final String amount;
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.upiId,
    required this.amount,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id']?.toString() ?? '',
      upiId: json['upi_id'] ?? '',
      amount: json['amount'] ?? '0.00',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'upi_id': upiId,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get qrData => "upi://pay?pa=$upiId&am=$amount&cu=INR";
}