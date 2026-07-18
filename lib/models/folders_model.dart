class FoldersModel {
  final String id;
  final String? name;
  final String? path;
  final int? items;

  FoldersModel({required this.id, this.name, this.path, this.items});

  static FoldersModel? fromJson(Map<dynamic, dynamic> json) {
    if (json.isEmpty) {
      return null;
    }

    return FoldersModel(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      items: json['items'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'items': items,
    };
  }
}