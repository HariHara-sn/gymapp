class ReportMemberModel {
  final String id;
  final String name;
  final String paymentMethod;
  final String paymentStatus;
  final String gymId;

  ReportMemberModel({
    required this.id,
    required this.name,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.gymId,
  });

  factory ReportMemberModel.fromJson(Map<String, dynamic> json) {
    return ReportMemberModel(
      id: json['member_id'].toString(),
      name: json['name'].toString(),
      paymentMethod: json['payment_method'].toString(),
      paymentStatus: json['payment_status'].toString(),
      gymId: json['gymId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member_id': id,
      'name': name,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'gymId': gymId,
    };
  }
}

class Report {
  final List<ReportMemberModel> members;
  final String? month;
  final bool isYearly;

  Report({required this.members, this.month, required this.isYearly});

  int get paidCount =>
      members.where((m) => m.paymentStatus.startsWith('Paid')).length;
  int get pendingCount =>
      members.where((m) => m.paymentStatus == 'Pending').length;
}
