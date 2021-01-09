import 'package:nalia_app/models/api.controller.dart';
import 'package:nalia_app/services/app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rxdart/rxdart.dart';

final App app = App();

/// Getx local storage
GetStorage localStorage;
BehaviorSubject<bool> localStorageReady = BehaviorSubject.seeded(false);

///
final api = API();
