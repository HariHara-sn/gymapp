class Member {
  final String? gymId;
  final String? name;
  final String? mobile;
  final String? gender;
  final String? height;
  final String? weight;
  final String? chest;
  final String? waist;
  final String? dob;
  final String? address;
  final String? training;
  final String? batchTime;
  final String? email;
  final String? employer;
  final String? occupation;
  final String? emergencyName;
  final String? emergencyAddress;
  final String? emergencyRelationship;
  final String? emergencyPhone;
  final String? memberImg;
  final String? memberPlan;
  final String? paymentMethod;
  final String? fromJoiningDate;
  final String? toJoiningDate;
  final String? paidAmount;
  final String? paidDate;
  final String? dueAmount;
  final String? paymentStatus;

  Member({
    this.gymId,
    this.name,
    this.mobile,
    this.gender,
    this.height,
    this.weight,
    this.chest,
    this.waist,
    this.dob,
    this.address,
    this.training,
    this.batchTime,
    this.email,
    this.employer,
    this.occupation,
    this.emergencyName,
    this.emergencyAddress,
    this.emergencyRelationship,
    this.emergencyPhone,
    this.memberImg,
    this.memberPlan,
    this.paymentMethod,
    this.fromJoiningDate,
    this.toJoiningDate,
    this.paidAmount,
    this.paidDate,
    this.dueAmount,
    this.paymentStatus = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'gymId': gymId ?? '',
      'name': name ?? '',
      'mobile': mobile ?? '',
      'gender': gender ?? '',
      'height': height ?? '',
      'weight': weight ?? '',
      'chest': chest ?? '',
      'waist': waist ?? '',
      'dob': dob ?? '',
      'address': address ?? '',
      'training': training ?? '',
      'batch_time': batchTime ?? '',
      'email': email ?? '',
      'employer': employer ?? '',
      'occupation': occupation ?? '',
      'emergency_name': emergencyName ?? '',
      'emergency_address': emergencyAddress ?? '',
      'emergency_relationship': emergencyRelationship ?? '',
      'emergency_phone': emergencyPhone ?? '',
      'member_img': memberImg ?? '',
      'member_plan': memberPlan ?? '',
      'payment_method': paymentMethod ?? '',
      'from_joining_date': fromJoiningDate ?? '',
      'to_joining_date': toJoiningDate ?? '',
      'paid_amount': paidAmount ?? '',
      'paid_date': paidDate ?? '',
      'due_amount': dueAmount ?? '',
      'payment_status': paymentStatus ?? 'Pending',
    };
  }
}