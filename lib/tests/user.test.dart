import 'dart:math';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UserTest {
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
      'height': (150 + i).toString(),
      'weight': (50 + i).toString(),
      'hobby': Hobbies[Random().nextInt(Hobbies.length)],
      'city': Cities[Random().nextInt(Cities.length)],
      'dateMethod': DateMethods[Random().nextInt(DateMethods.length)],
    };
  }

  generate() async {
    try {
      for (int i = 0; i < 40; i++) {
        final temp = UserTest().data(i);
        final re = await api.loginOrRegister(
            email: temp['user_email'], pass: temp['user_pass'], data: temp);
        print('re: $re');
        await api.appUpdate('bio', 'name', temp['name']);
        await api.appUpdate('bio', 'gender', temp['gender']);
        await api.appUpdate('bio', 'birthdate', temp['birthdate']);
        await api.appUpdate('bio', 'height', temp['height']);
        await api.appUpdate('bio', 'weight', temp['weight']);
        await api.appUpdate('bio', 'hobby', temp['hobby']);
        await api.appUpdate('bio', 'city', temp['city']);
        await api.appUpdate('bio', 'dateMethod', temp['dateMethod']);
      }
    } catch (e) {
      print(e);
      app.error(e);
    }
  }

  Future<File> downloadImage(String url) async {
    var tempDir = await getTemporaryDirectory();
    String savePath = tempDir.path + "/image.jpg'";
    print('save path $savePath');

    Dio dio = Dio();

    Response response = await dio.get(
      url,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      },
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    print(response.headers);
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return File(savePath);
  }
}
