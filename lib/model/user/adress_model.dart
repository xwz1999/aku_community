class AddressModel {
  int?id;
  String? name;
  String? tel;
  int? location;
  String? locationName;

  String? addressDetail;
  int? isDefault;

  String? province;
  String? city;
  String? district;



  AddressModel(
      {this.id,
        this.name,
        this.tel,
        this.location,
        this.locationName,
        this.addressDetail,
        this.isDefault,
        this.province = '',
        this.city = '',
        this.district = '',
      });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tel = json['tel'];
    location = json['location'];
    locationName = json['locationName'];
    addressDetail = json['addressDetail'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['tel'] = this.tel;
    data['location'] = this.location;
    data['locationName'] = this.locationName;
    data['addressDetail'] = this.addressDetail;
    data['isDefault'] = this.isDefault;
    return data;
  }

  factory AddressModel.empty() {
    return AddressModel(id: null,name: '',tel: '',location: null,locationName: '',addressDetail: '',isDefault: null);
  }
}