class Member {
  final String name;
  final String paymentMethod;
  final double paidAmount;
  final String paidDate;

  Member({
    required this.name,
    required this.paymentMethod,
    required this.paidAmount,
    required this.paidDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      paymentMethod: json['payment_method'],
      paidAmount: (json['paid_amount'] as num).toDouble(),
      paidDate: json['paid_date'],
    );
  }
}
