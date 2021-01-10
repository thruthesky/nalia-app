import 'package:age/age.dart';

class ApiUser {
  String nickname;
  String firstName;
  String lastName;
  String locale;
  String autoLoginYn;
  String autoStatusCheck;
  String plid;
  String agegroup;
  String get age {
    final _yy = int.parse(birthdate.substring(0, 2));
    final _mm = int.parse(birthdate.substring(2, 4));
    final _dd = int.parse(birthdate.substring(4, 6));

    DateTime birthday = DateTime(_yy < 20 ? 2000 + _yy : 1900 + _yy, _mm, _dd);

    DateTime today = DateTime.now();

    AgeDuration _age;

    // Set the age of the user
    _age = Age.dateDifference(
        fromDate: birthday, toDate: today, includeToDate: false);

    return _age.years.toString();
  }

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

  /// [mode] is used only when `loginOrRegister` method is being invoked.
  /// It is one of `login` or `register`.
  String mode;
  String primaryPhotoUrl;
  String get fullName => name;
  String dateMethod;
  String height;
  String weight;
  String city;
  String hobby;
  String drinking;
  String smoking;

  ApiUser({
    this.nickname,
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
    this.mode,
    this.primaryPhotoUrl,
    this.dateMethod,
    this.height,
    this.weight,
    this.city,
    this.hobby,
    this.drinking,
    this.smoking,
  });

  ApiUser.fromJson(Map<String, dynamic> json) {
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
    primaryPhotoUrl = json['primaryPhotoUrl'];

    dateMethod = json['dateMethod'] ?? '';
    height = json['height'] ?? '';
    weight = json['weight'] ?? '';
    city = json['city'] ?? '';
    hobby = json['hobby'] ?? '';
    drinking = json['drinking'] ?? '';
    smoking = json['smoking'] ?? '';
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
    data['primaryPhotoUrl'] = this.primaryPhotoUrl;
    data['dateMethod'] = this.dateMethod;
    data['height'] = this.height;
    data['weight'] = this.weight;

    data['city'] = this.city;
    data['hobby'] = this.hobby;
    data['drinking'] = this.drinking;
    data['smoking'] = this.smoking;

    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
