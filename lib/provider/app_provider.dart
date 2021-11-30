import 'dart:io';

import 'package:aku_community/constants/api.dart';
import 'package:aku_community/constants/application_objects.dart';
import 'package:aku_community/constants/config.dart';
import 'package:aku_community/model/common/real_time_weather_model.dart';
import 'package:aku_community/model/community/hot_topic_model.dart';
import 'package:aku_community/model/message/message_center_model.dart';
import 'package:aku_community/model/user/adress_model.dart';
import 'package:aku_community/model/user/car_parking_model.dart';
import 'package:aku_community/models/user/passed_house_list_model.dart';
import 'package:aku_community/utils/hive_store.dart';
import 'package:aku_community/utils/network/base_model.dart';
import 'package:aku_community/utils/network/net_util.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:power_logger/power_logger.dart';

class AppProvider extends ChangeNotifier {
  ///初始值为
  ///
  ///```
  ///'一键开门',
  /// '访客邀请',
  /// '报事报修',
  /// '生活缴费',
  /// '业委会',
  /// '建议投诉',
  /// '便民电话',
  ///```
  List<AO> _myApplications = [
    // '一键开门',
    '访客邀请',
    '报事报修',
    '生活缴费',
    '业委会',
    '建议咨询',
    '便民电话',
  ].map((e) => AO.fromRaw(e)).toList();

  ///我的应用
  List<AO> get myApplications {
    return _myApplications;
  }

  ///初始化我的应用
  initApplications() {
    if (HiveStore.appBox!.containsKey('app'))
      _myApplications = (HiveStore.appBox!.get('app') as List<String>)
          .map((e) => AO.fromRaw(e))
          .toList();
    notifyListeners();
  }

  ///添加我的应用
  insertApplication(AO app) {
    if (!_myApplications.contains(app) && _myApplications.length < 7)
      _myApplications.insert(0, app);
    if (!_myApplications.contains(app) && _myApplications.length >= 7) {
      _myApplications.insert(0, app);
      _myApplications.removeLast();
    }
    HiveStore.appBox!.put('app', _myApplications.map((e) => e.title).toList());
    notifyListeners();
  }

  ///移除我的应用
  removeApplication(AO obj) {
    if (_myApplications.remove(obj)) {
      HiveStore.appBox!
          .put('app', _myApplications.map((e) => e.title).toList());
      notifyListeners();
    }
  }

  List<HotTopicModel> _hotTopicModels = [];

  List<HotTopicModel> get hotTopicModels => _hotTopicModels;

  updateHotTopicModel() async {
    BaseModel model = await NetUtil().get(API.community.hotTopic);
    _hotTopicModels =
        (model.data as List).map((e) => HotTopicModel.fromJson(e)).toList();
    notifyListeners();
  }

  RealTimeWeatherModel? _weatherModel;

  RealTimeWeatherModel? get weatherModel => _weatherModel;

  String get weatherTemp =>
      _weatherModel?.result?.realtime?.temperature?.toStringAsFixed(0) ?? '';

  String get weatherType {
    if (_weatherModel?.result?.realtime?.skycon == null) return '';
    switch (_weatherModel!.result!.realtime!.skycon) {
      case 'CLEAR_DAY':
      case 'CLEAR_NIGHT':
        return '晴';
      case 'PARTLY_CLOUDY_DAY':
      case 'PARTLY_CLOUDY_NIGHT':
        return '多云';
      case 'CLOUDY':
        return '阴';
      case 'LIGHT_HAZE':
        return '轻度雾霾';
      case 'MODERATE_HAZE':
        return '中度雾霾';
      case 'HEAVY_HAZE':
        return '重度雾霾';
      case 'LIGHT_RAIN':
        return '小雨';
      case 'MODERATE_RAIN':
        return '中雨';
      case 'HEAVY_RAIN':
        return '大雨';
      case 'STORM_RAIN':
        return '暴雨';
      case 'FOG':
        return '雾';
      case 'LIGHT_SNOW':
        return '小雪';
      case 'MODERATE_SNOW':
        return '中雪';
      case 'HEAVY_SNOW':
        return '大雪';
      case 'STORM_SNOW':
        return '暴雪';
      case 'DUST':
        return '浮尘';
      case 'SAND':
        return '沙尘';
      case 'WIND':
        return '大风';
      default:
        return '';
    }
  }

  Map<String, dynamic>? _location;

  Map<String, dynamic>? get location => _location;
  late AMapFlutterLocation _aMapFlutterLocation;

  startLocation() {
    if (kIsWeb || Platform.isMacOS) {
      getWeather();
      return;
    }
    _aMapFlutterLocation = AMapFlutterLocation();

    _aMapFlutterLocation.onLocationChanged().listen((event) {
      _location = event;
      if (_location != null) {
        getWeather();
        stopLocation();
      }
    });
    _aMapFlutterLocation
        .setLocationOption(AMapLocationOption(onceLocation: true));
    _aMapFlutterLocation.startLocation();
  }

  stopLocation() {
    if (kIsWeb || Platform.isMacOS) return;
    _aMapFlutterLocation.stopLocation();
    _aMapFlutterLocation.destroy();
  }

  getWeather() async {
    late num longitude;
    late num latitude;
    if (kIsWeb || Platform.isMacOS) {
      longitude = 116.46;
      latitude = 39.92;
    } else {
      longitude = _location?['longitude'] ?? 116.46;
      latitude = _location?['latitude'] ?? 39.92;
    }

    Response response = await Dio().get(
      'https://api.caiyunapp.com/v2.5/${AppConfig.caiYunAPI}/$longitude,$latitude/realtime.json',
    );
    LoggerData.addData(response);
    _weatherModel = RealTimeWeatherModel.fromJson(response.data);
    notifyListeners();
  }

  /// 消息中心
  MessageCenterModel? _messageCenterModel;

  MessageCenterModel get messageCenterModel =>
      _messageCenterModel ?? MessageCenterModel.zero();

  getMessageCenter() async {
    Response response = await NetUtil().dio!.get(API.message.center);
    _messageCenterModel = MessageCenterModel.fromJson(response.data);
    notifyListeners();
  }

  List<PassedHouseListModel> _houses = [];

  ///我的房屋列表
  List<PassedHouseListModel> get houses => _houses;

  ///更新房屋列表
  updateHouses(List<PassedHouseListModel> items) {
    if (items.isEmpty) return;
    _selectedHouse = items.firstWhereOrNull(
      (element) => element.id == _selectedHouseId,
    );
    _houses = items;
    notifyListeners();
  }

  PassedHouseListModel? _selectedHouse;

  ///选中的房屋id；
  int _selectedHouseId = -1;

  int get selectHouseId => _selectedHouseId;

  void setCurrentHouseId(int? id) {
    if (id != null) {
      _selectedHouseId = id;
    }
  }

  ///选中的房屋
  PassedHouseListModel? get selectedHouse {
    if (_selectedHouse == null) {
      if (_houses.isEmpty) return null;
      if (_selectedHouseId != -1) {
        _selectedHouse = _houses.firstWhereOrNull(
            (element) => element.estateId == _selectedHouseId);
      } else {
        _selectedHouseId = _houses.first.estateId;
        _selectedHouse = _houses.first;
      }
    }
    return _selectedHouse;
  }

  ///设置当前选中的房屋
  setCurrentHouse(PassedHouseListModel? model) {
    if (model != null) {
      _selectedHouse = model;
      _selectedHouseId = model.estateId;
    } else {
      _selectedHouse = null;
    }
    notifyListeners();
  }

  List<CarParkingModel> _carParkingModels = [];

  List<CarParkingModel> get carParkingModels => _carParkingModels;

  Future updateCarParkingModels() async {
    BaseModel baseModel = await NetUtil().get(API.user.carParkingList);
    if (baseModel.data == null) return [];
    _carParkingModels = (baseModel.data as List)
        .map((e) => CarParkingModel.fromJson(e))
        .toList();
    notifyListeners();
  }

  List<CarParkingModel> _carModels = [];

  List<CarParkingModel> get carModels => _carModels;

  Future updateCarModels() async {
    BaseModel baseModel = await NetUtil().get(
      API.user.carList,
      params: {'estateId': selectedHouse?.estateId ?? 0},
    );
    if (baseModel.data == null) return [];
    _carModels = (baseModel.data as List)
        .map((e) => CarParkingModel.fromJson(e))
        .toList();
    notifyListeners();
  }

  //设置火灾报警开关
  bool _fireAlert = true;

  bool get fireAlert => _fireAlert;

  void setFireAlert(bool value) {
    _fireAlert = value;
    notifyListeners();
  }

  List<AddressModel> _addressModels = [];
  List<AddressModel> get addressModels => _addressModels;


  AddressModel? _addressModel;

  AddressModel? get addressModel => _addressModel;

  ///设置当前选中的房屋


  ///保存默认收货地址
   Future getMyAddress() async {
    BaseModel model = await NetUtil().get(
      API.user.myAddressList,
    );
    if (model.data!.length == 0)
      return [];
    else{
      _addressModels =  (model.data as List)
          .map((e) => AddressModel.fromJson(e))
          .toList();

        if (_addressModels.isEmpty) {
          _addressModel = null;
        } else {
          _addressModels.forEach((element) {
            if(element.isDefault==1){
              _addressModel = element;
            }
          });
        }

    }

    notifyListeners();
  }




}
