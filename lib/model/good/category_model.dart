class CategoryModel {
  int? id;
  String? name;
  List<String>? imgUrls;
  List<CategoryList>? categoryList;

  CategoryModel({this.id, this.name, this.categoryList,this.imgUrls});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['imgUrls'] != null) {
      imgUrls =  [];
      json['imgUrls'].forEach((v) {
        imgUrls!.add(v.toString());
      });
    }
    if (json['categoryList'] != null) {
      categoryList =  [];
      json['categoryList'].forEach((v) {
        categoryList!.add(new CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.categoryList != null) {
      data['categoryList'] = this.categoryList!.map((v) => v.toJson()).toList();
    }
    if (this.imgUrls != null) {
      data['imgUrls'] = this.imgUrls!.map((v) => v).toList();
    }
    return data;
  }
}

class CategoryList {
  int? id;
  List<String>? imgUrls;
  String? name;
  List<CategoryListSecond>? categoryListSecond;

  CategoryList({this.id, this.name, this.categoryListSecond});

  CategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['categoryList'] != null) {
      categoryListSecond = [];
      json['categoryList'].forEach((v) {
        categoryListSecond!.add(new CategoryListSecond.fromJson(v));
      });
    }
    if (json['imgUrls'] != null) {
      imgUrls =  [];
      json['imgUrls'].forEach((v) {
        imgUrls!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.categoryListSecond != null) {
      data['categoryList'] =
          this.categoryListSecond!.map((v) => v.toJson()).toList();
    }
    if (this.imgUrls != null) {
      data['imgUrls'] = this.imgUrls!.map((v) => v).toList();
    }
    return data;
  }
}

class CategoryListSecond {
  int? id;
  String? name;
  List<String>? imgUrls;

  CategoryListSecond({this.id, this.name,});

  CategoryListSecond.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['imgUrls'] != null) {
      imgUrls =  [];
      json['imgUrls'].forEach((v) {
        imgUrls!.add(v.toString());
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.imgUrls != null) {
      data['imgUrls'] = this.imgUrls!.map((v) => v).toList();
    }
    return data;
  }
}