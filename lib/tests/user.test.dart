import 'dart:io';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:nalia_app/services/config.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:withcenter/withcenter.dart';

const List<Map<String, double>> locations = [
  {'latitude': 14.5827134, 'longitude': 120.9777218},
  {'latitude': 14.5843948, 'longitude': 120.9754953, 'rizal': 0.30},
  {'latitude': 14.5747701, 'longitude': 120.9915513, 'rizal': 1.73},
  {'latitude': 14.5550189, 'longitude': 120.9809992, 'rizal': 3.10},
  {'latitude': 14.651424, 'longitude': 121.0483225, 'rizal': 10.77},
  {'latitude': 15.1689815, 'longitude': 120.5793488, 'rizal': 77.99},
  {'latitude': 37.5297347, 'longitude': 126.9644588, 'rizal': 2619.15},
  {'latitude': 35.1586788, 'longitude': 129.1597749, 'youngsan_station': 328.87},
];

class UserTest {
  data(int i) {
    String gender = i % 2 == 0 ? 'M' : 'F';

    int phoneNo = 1012345678 + i;

    final birthday = DateTime(1960 + i, i % 12, i % 30);

    final g = locations.elementAt(Random().nextInt(locations.length));

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
      'latitude': g['latitude'].toString(),
      'longitude': g['longitude'].toString(),
    };
  }

  generate() async {
    try {
      for (int i = 0; i < 40; i++) {
        final temp = UserTest().data(i);
        withcenterApi.logout();
        await withcenterApi.loginOrRegister(email: temp['user_email'], pass: temp['user_pass'], data: temp);
        await withcenterApi.appUpdate(BIO_TABLE, 'name', temp['name']);
        await withcenterApi.appUpdate(BIO_TABLE, 'gender', temp['gender']);
        await withcenterApi.appUpdate(BIO_TABLE, 'birthdate', temp['birthdate']);
        await withcenterApi.appUpdate(BIO_TABLE, 'height', temp['height']);
        await withcenterApi.appUpdate(BIO_TABLE, 'weight', temp['weight']);
        await withcenterApi.appUpdate(BIO_TABLE, 'hobby', temp['hobby']);
        await withcenterApi.appUpdate(BIO_TABLE, 'city', temp['city']);
        await withcenterApi.appUpdate(BIO_TABLE, 'dateMethod', temp['dateMethod']);
        await withcenterApi.appUpdate(BIO_TABLE, 'latitude', temp['latitude']);
        await withcenterApi.appUpdate(BIO_TABLE, 'longitude', temp['longitude']);

        /// Setting primary photo. 대표 사진 추가.
        ApiPost gallery = await app.getGalleryPost();
        await withcenterApi.deletePost(gallery);
        gallery = await app.getGalleryPost();
        // print('user_ID: ${gallery.postAuthor}');
        File file = await app.downloadImage(url: Config.backendThemeUrl + '/tmp/img/${i + 1}.jpg');
        // print('file:');
        // print(file);
        ApiFile uploadedFile = await withcenterApi.uploadFile(file: file, onProgress: (p) => null);
        // print(uploadedFile);
        ApiPost uploadedPost = await withcenterApi.editPost(id: gallery.id, files: [uploadedFile]);
        // print(uploadedPost);
        await withcenterApi.setFeaturedImage(uploadedPost, uploadedFile);
        await withcenterApi.updateBio('profile_photo_url', uploadedFile.url);

        // 0 개에서 9개 사이로 이미지를 랜덤으로 추가한다.
        int n = Random().nextInt(10);
        List rnd = List.generate(40, (r) => r);
        rnd.shuffle();
        // print(rnd);
        for (int j = 0; j < n; j++) {
          if (j == i) continue;

          File file = await app.downloadImage(url: Config.backendThemeUrl + '/tmp/img/${j + 1}.jpg');
          ApiFile uploadedFile = await withcenterApi.uploadFile(file: file, onProgress: (p) => null);
          uploadedPost.files.add(uploadedFile);
        }
        await withcenterApi.editPost(id: gallery.id, files: uploadedPost.files);
      }
    } catch (e) {
      print(e);
      app.error(e);
    }
  }
}
