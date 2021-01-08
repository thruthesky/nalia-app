import 'package:intl/intl.dart';
import 'package:faker/faker.dart';

class TestUser {
  data(int i) {
    String gender = i % 2 == 0 ? 'M' : 'F';

    int phoneNo = 1012345678 + i;

    final birthday = DateTime(1960 + i, i % 12, i % 30);

    return {
      'user_email': 'emaila$i@test.com',
      'user_pass': '12345a,*',
      'gender': gender,
      'name': Faker().person.name(),
      'phoneNo': '0$phoneNo',
      'birthdate': DateFormat('yyMMdd').format(birthday),
    };
  }
}
