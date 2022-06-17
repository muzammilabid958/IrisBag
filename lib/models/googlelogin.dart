class GoogleLoginModel {
  GoogleLoginModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isSocial,
    required this.name,
  });
  late final String email;
  late final String firstName;
  late final String lastName;
  late final String isSocial;
  late final String name;

  GoogleLoginModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isSocial = json['is_social'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['is_social'] = isSocial;
    _data['name'] = name;
    return _data;
  }
}
