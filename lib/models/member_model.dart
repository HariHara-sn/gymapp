class Member {
  String memberId;
  String gymId;
  String name;
  String mobile;
  String gender;
  String height;
  String weight;
  String chest;
  String waist;
  String dob;
  String address;
  String training;
  String batchTime;
  String email;
  String employer;
  String occupation;
  String emergencyName;
  String emergencyAddress;
  String emergencyRelationship;
  String emergencyPhone;
  String memberImg;
  String memberPlan;
  String paymentMethod;
  String fromJoiningDate;
  String toJoiningDate;
  String paidAmount;
  String paidDate;
  String dueAmount;
  String paymentStatus;

  Member({
    this.memberId = '',
    this.gymId = '',
    this.name = '',
    this.mobile = '',
    this.gender = 'Male',
    this.height = '',
    this.weight = '',
    this.chest = '',
    this.waist = '',
    this.dob = '',
    this.address = '',
    this.training = 'Trainer',
    this.batchTime = '',
    this.email = '',
    this.employer = '',
    this.occupation = '',
    this.emergencyName = '',
    this.emergencyAddress = '',
    this.emergencyRelationship = '',
    this.emergencyPhone = '',
    this.memberImg = '',
    this.memberPlan = '',
    this.paymentMethod = '',
    this.fromJoiningDate = '',
    this.toJoiningDate = '',
    this.paidAmount = '',
    this.paidDate = '',
    this.dueAmount = '',
    this.paymentStatus = 'Pending',
  });


  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      memberId: map['member_id'] ?? '',
      gymId: map['gymId'] ?? '',
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      gender: map['gender'] ?? 'Male',
      height: map['height'] ?? '',
      weight: map['weight'] ?? '',
      chest: map['chest'] ?? '',
      waist: map['waist'] ?? '',
      dob: map['dob'] ?? '',
      address: map['address'] ?? '',
      training: map['training'] ?? 'Trainer',
      batchTime: map['batch_time'] ?? '',
      email: map['email'] ?? '',
      employer: map['employer'] ?? '',
      occupation: map['occupation'] ?? '',
      emergencyName: map['emergency_name'] ?? '',
      emergencyAddress: map['emergency_address'] ?? '',
      emergencyRelationship: map['emergency_relationship'] ?? '',
      emergencyPhone: map['emergency_phone'] ?? '',
      memberImg: map['member_img'] ?? '',
      memberPlan: map['member_plan'] ?? '',
      paymentMethod: map['payment_method'] ?? '',
      fromJoiningDate: map['from_joining_date'] ?? '',
      toJoiningDate: map['to_joining_date'] ?? '',
      paidAmount: map['paid_amount'] ?? '',
      paidDate: map['paid_date'] ?? '',
      dueAmount: map['due_amount'] ?? '',
      paymentStatus: map['payment_status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'member_id': memberId,
      'gymId': gymId,
      'name': name,
      'mobile': mobile,
      'gender': gender,
      'height': height,
      'weight': weight,
      'chest': chest,
      'waist': waist,
      'dob': dob,
      'address': address,
      'training': training,
      'batch_time': batchTime,
      'email': email,
      'employer': employer,
      'occupation': occupation,
      'emergency_name': emergencyName,
      'emergency_address': emergencyAddress,
      'emergency_relationship': emergencyRelationship,
      'emergency_phone': emergencyPhone,
      'member_img': memberImg,
      'member_plan': memberPlan,
      'payment_method': paymentMethod,
      'from_joining_date': fromJoiningDate,
      'to_joining_date': toJoiningDate,
      'paid_amount': paidAmount,
      'paid_date': paidDate,
      'due_amount': dueAmount,
      'payment_status': paymentStatus,
    };
  }
}