class LastPlayedModel {
  String? id;
  int? position;
  
  LastPlayedModel({this.id, this.position});

  factory LastPlayedModel.fromJson(Map<dynamic, dynamic> json) {
    return LastPlayedModel(
      id: json['id'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
    };
  }
}
