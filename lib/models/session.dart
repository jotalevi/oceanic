class Session {
  final String id;
  final String code;
  final String name;
  final String teacher;
  final int color;

  Session({
    required this.id,
    required this.code,
    required this.name,
    required this.teacher,
    required this.color,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      teacher: json['teacher'],
      color: json['color'],
    );
  }

  static List<Session> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Session.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'teacher': teacher,
      'color': color,
    };
  }
}
