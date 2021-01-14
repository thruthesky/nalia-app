class ApiBioSearch {
  ApiBioSearch({
    this.ageFrom = 0,
    this.ageTo = 0,
    this.gender,
    this.heightFrom = 0,
    this.heightTo = 0,
    this.weightFrom = 0,
    this.weightTo = 0,
    this.city,
    this.hobby,
    this.drinking,
    this.smoking,
    this.location,
  });
  int ageFrom;
  int ageTo;

  String gender;

  int heightFrom;
  int heightTo;

  int weightFrom;
  int weightTo;

  String city;
  String hobby;
  String drinking;
  String smoking;
  int location;

  toJson() {
    return {
      'ageFrom': ageFrom,
      'ageTo': ageTo,
      'gender': gender,
      'heightFrom': heightFrom,
      'heightTo': heightTo,
      'weightFrom': weightFrom,
      'weightTo': weightTo,
      'city': city,
      'hobby': hobby,
      'drinking': drinking,
      'smoking': smoking,
      'location': location,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
