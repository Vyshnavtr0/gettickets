class usermodel {
  String? uid;
  String? email;
  String? name;
  String? photo;
  String? lan;
  String? lon;
  String? location;

  usermodel({
    this.email,
    this.name,
    this.uid,
    this.photo,
    this.lan,
    this.lon,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photo': photo,
      'lan': lan,
      'lon': lon,
      'location': location,
    };
  }
}
