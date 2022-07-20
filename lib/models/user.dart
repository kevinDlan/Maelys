class User {
  int? id;
  String? name;
  String? lastname;
  String? email;
  String? code;
  String? photopath;
  String? contact;

  User(
      {this.id,
      this.name,
      this.lastname,
      this.email,
      this.code,
      this.photopath,
      this.contact});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        lastname: json['lastname'],
        email: json['email'],
        code: json['code'],
        photopath: json['photo_path'],
        contact: json['contact']);
  }
}
