class ApiBio {
  ApiBio({
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.birthdate,
    this.gender,
    this.height,
    this.weight,
    this.city,
    this.drinking,
    this.smoking,
    this.hobby,
    this.dateMethod,
  });

  String userId;
  String createdAt;
  String updatedAt;
  String birthdate;
  String gender;
  String height;
  String weight;
  String city;
  String drinking;
  String smoking;
  String hobby;
  String dateMethod;

  factory ApiBio.fromJson(Map<String, dynamic> json) => ApiBio(
        userId: json["user_ID"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        birthdate: json["birthdate"],
        gender: json["gender"],
        height: json["height"],
        weight: json["weight"],
        city: json["city"],
        drinking: json["drinking"],
        smoking: json["smoking"],
        hobby: json["hobby"],
        dateMethod: json["dateMethod"],
      );

  Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "birthdate": birthdate,
        "gender": gender,
        "height": height,
        "weight": weight,
        "city": city,
        "drinking": drinking,
        "smoking": smoking,
        "hobby": hobby,
        "dateMethod": dateMethod,
      };
  @override
  String toString() {
    return toJson().toString();
  }
}
