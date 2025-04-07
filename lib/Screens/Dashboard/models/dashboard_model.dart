class Exercise {
  String title;
  String description;

  Exercise({required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'exercise_title': title,
      'exercise_desc': description,
    };
  }
}


class Notice {
  String title;
  String description;

  Notice({required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'notice_title': title,
      'notice_desc': description,
    };
  }
}
