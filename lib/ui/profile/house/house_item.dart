import 'package:flutter/foundation.dart';

import 'package:akuCommunity/model/user/pick_building_model.dart';

class HouseItem {
  PickBuildingModel building;
  PickBuildingModel house;
  HouseItem({
    @required this.building,
    @required this.house,
  });

  int get houseCode => house.value;

  String get houseName => '${building.label}-${house.label}';
}