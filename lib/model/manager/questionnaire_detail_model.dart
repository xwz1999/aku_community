class QuestionnaireDetialModel {
  int id;
  String title;
  String description;
  String beginDate;
  String endDate;
  List<QuestionnaireTopicVoList> questionnaireTopicVoList;
  List<VoResourcesImgList> voResourcesImgList;

  QuestionnaireDetialModel(
      {this.id,
      this.title,
      this.description,
      this.beginDate,
      this.endDate,
      this.questionnaireTopicVoList,
      this.voResourcesImgList});

  QuestionnaireDetialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    beginDate = json['beginDate'];
    endDate = json['endDate'];
    if (json['questionnaireTopicVoList'] != null) {
      questionnaireTopicVoList = new List<QuestionnaireTopicVoList>();
      json['questionnaireTopicVoList'].forEach((v) {
        questionnaireTopicVoList.add(new QuestionnaireTopicVoList.fromJson(v));
      });
    }
    if (json['voResourcesImgList'] != null) {
      voResourcesImgList = new List<VoResourcesImgList>();
      json['voResourcesImgList'].forEach((v) {
        voResourcesImgList.add(new VoResourcesImgList.fromJson(v));
      });
    } else
      voResourcesImgList = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['beginDate'] = this.beginDate;
    data['endDate'] = this.endDate;
    if (this.questionnaireTopicVoList != null) {
      data['questionnaireTopicVoList'] =
          this.questionnaireTopicVoList.map((v) => v.toJson()).toList();
    }
    if (this.voResourcesImgList != null) {
      data['voResourcesImgList'] =
          this.voResourcesImgList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionnaireTopicVoList {
  int id;
  int type;
  String topic;
  List<QuestionnaireChoiceVoList> questionnaireChoiceVoList;

  QuestionnaireTopicVoList(
      {this.id, this.type, this.topic, this.questionnaireChoiceVoList});

  QuestionnaireTopicVoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    topic = json['topic'];
    if (json['questionnaireChoiceVoList'] != null) {
      questionnaireChoiceVoList = new List<QuestionnaireChoiceVoList>();
      json['questionnaireChoiceVoList'].forEach((v) {
        questionnaireChoiceVoList
            .add(new QuestionnaireChoiceVoList.fromJson(v));
      });
    } else
      questionnaireChoiceVoList = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['topic'] = this.topic;
    if (this.questionnaireChoiceVoList != null) {
      data['questionnaireChoiceVoList'] =
          this.questionnaireChoiceVoList.map((v) => v.toJson()).toList();
    } else
      questionnaireChoiceVoList = [];
    return data;
  }
}

class QuestionnaireChoiceVoList {
  int id;
  String options;
  String answer;

  QuestionnaireChoiceVoList({this.id, this.options, this.answer});

  QuestionnaireChoiceVoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    options = json['options'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['options'] = this.options;
    data['answer'] = this.answer;
    return data;
  }
}

class VoResourcesImgList {
  String url;
  String size;
  int longs;
  int paragraph;
  int sort;

  VoResourcesImgList(
      {this.url, this.size, this.longs, this.paragraph, this.sort});

  VoResourcesImgList.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    size = json['size'];
    longs = json['longs'];
    paragraph = json['paragraph'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['size'] = this.size;
    data['longs'] = this.longs;
    data['paragraph'] = this.paragraph;
    data['sort'] = this.sort;
    return data;
  }
}
