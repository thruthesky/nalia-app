class User {
  String nickname;
  String firstName;
  String lastName;
  String locale;
  String autoLoginYn;
  String autoStatusCheck;
  String plid;
  String agegroup;
  String gender;
  String foreign;
  String telcoCd;
  String ci;
  String phoneNo;
  String name;
  String birthday;
  String birthdate;
  String iD;
  String userLogin;
  String userEmail;
  String userRegistered;
  String sessionId;
  String mode;

  User(
      {this.nickname,
      this.firstName,
      this.lastName,
      this.locale,
      this.autoLoginYn,
      this.autoStatusCheck,
      this.plid,
      this.agegroup,
      this.gender,
      this.foreign,
      this.telcoCd,
      this.ci,
      this.phoneNo,
      this.name,
      this.birthday,
      this.birthdate,
      this.iD,
      this.userLogin,
      this.userEmail,
      this.userRegistered,
      this.sessionId,
      this.mode});

  User.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    locale = json['locale'];
    autoLoginYn = json['autoLoginYn'];
    autoStatusCheck = json['autoStatusCheck'];
    plid = json['plid'];
    agegroup = json['agegroup'];
    gender = json['gender'];
    foreign = json['foreign'];
    telcoCd = json['telcoCd'];
    ci = json['ci'];
    phoneNo = json['phoneNo'];
    name = json['name'];
    birthday = json['birthday'];
    birthdate = json['birthdate'];
    iD = json['ID'];
    userLogin = json['user_login'];
    userEmail = json['user_email'];
    userRegistered = json['user_registered'];
    sessionId = json['session_id'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['locale'] = this.locale;
    data['autoLoginYn'] = this.autoLoginYn;
    data['autoStatusCheck'] = this.autoStatusCheck;
    data['plid'] = this.plid;
    data['agegroup'] = this.agegroup;
    data['gender'] = this.gender;
    data['foreign'] = this.foreign;
    data['telcoCd'] = this.telcoCd;
    data['ci'] = this.ci;
    data['phoneNo'] = this.phoneNo;
    data['name'] = this.name;
    data['birthday'] = this.birthday;
    data['birthdate'] = this.birthdate;
    data['ID'] = this.iD;
    data['user_login'] = this.userLogin;
    data['user_email'] = this.userEmail;
    data['user_registered'] = this.userRegistered;
    data['session_id'] = this.sessionId;
    data['mode'] = this.mode;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
