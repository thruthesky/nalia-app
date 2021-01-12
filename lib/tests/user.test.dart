import 'dart:io';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:nalia_app/models/api.bio.controller.dart';
import 'package:nalia_app/models/api.file.model.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/services/config.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';

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
        api.logout();
        await api.loginOrRegister(email: temp['user_email'], pass: temp['user_pass'], data: temp);
        // print('re: $re');
        await api.appUpdate('bio', 'name', temp['name']);
        await api.appUpdate('bio', 'gender', temp['gender']);
        await api.appUpdate('bio', 'birthdate', temp['birthdate']);
        await api.appUpdate('bio', 'height', temp['height']);
        await api.appUpdate('bio', 'weight', temp['weight']);
        await api.appUpdate('bio', 'hobby', temp['hobby']);
        await api.appUpdate('bio', 'city', temp['city']);
        await api.appUpdate('bio', 'dateMethod', temp['dateMethod']);

        /// Setting primary photo. 대표 사진 추가.
        ApiPost gallery = await app.getGalleryPost();
        await api.deletePost(gallery);
        gallery = await app.getGalleryPost();
        // print('user_ID: ${gallery.postAuthor}');
        File file = await app.downloadImage(url: Config.backendSiteUrl + '/tmp/img/${i + 1}.jpg');
        // print('file:');
        // print(file);
        ApiFile uploadedFile = await api.uploadFile(file: file, onProgress: (p) => null);
        // print(uploadedFile);
        ApiPost uploadedPost = await api.editPost(id: gallery.id, files: [uploadedFile]);
        // print(uploadedPost);
        await api.setFeaturedImage(uploadedPost, uploadedFile);
        await Bio.to.updateBio('profile_photo_url', uploadedFile.url);

        // 0 개에서 9개 사이로 이미지를 랜덤으로 추가한다.
        int n = Random().nextInt(10);
        List rnd = List.generate(40, (r) => r);
        rnd.shuffle();
        // print(rnd);
        for (int j = 0; j < n; j++) {
          if (j == i) continue;

          File file = await app.downloadImage(url: Config.backendSiteUrl + '/tmp/img/${j + 1}.jpg');
          ApiFile uploadedFile = await api.uploadFile(file: file, onProgress: (p) => null);
          uploadedPost.files.add(uploadedFile);
        }
        await api.editPost(id: gallery.id, files: uploadedPost.files);
      }
    } catch (e) {
      print(e);
      app.error(e);
    }
  }
}
