class Teacher {
  final String id;
  final String fullname;
  final String mail;
  final String phoneNumber;

  Teacher({
    required this.id,
    required this.fullname,
    required this.mail,
    required this.phoneNumber,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      fullname: json['fullname'],
      mail: json['mail'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'mail': mail,
      'phoneNumber': phoneNumber,
    };
  }
}
