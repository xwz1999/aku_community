import 'package:aku_community/model/user/province_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveStore {
  static Box? _appBox;
  static Box? get appBox => _appBox;
  static Future init() async {
    if (!kIsWeb) {
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      Hive.registerAdapter(ProvinceModelAdapter());
      Hive.registerAdapter(CityAdapter());
      Hive.registerAdapter(DistrictAdapter());
      _appBox = await Hive.openBox('app');
    }


  }

}
