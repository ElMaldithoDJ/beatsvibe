import 'package:beatsvibe/models/mediaitem_data.dart';

class PlaylistModelData {
  final String? id;
  final String title;
  final String? description;
  final String? artwork;
  final List<MediaItemData>? songs;

  PlaylistModelData({
    required this.title,
    this.id,
    this.description,
    this.artwork,
    this.songs,
  });

  factory PlaylistModelData.fromJson(Map<dynamic, dynamic> json) {
    return PlaylistModelData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      artwork: json['artwork'],
      songs: json['songs'] != null
          ? (json['songs'] as List<dynamic>)
              .map((e) => MediaItemData.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'artwork': artwork,
      'songs': songs?.map((e) => e.toJson()).toList(),
    };
  }
}
