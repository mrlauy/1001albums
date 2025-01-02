import 'package:albums/models/track.dart';

class AlbumDetails {
  final String? info;
  final String? cover;
  final List<Track> tracks;
  final List<String> tags;

  const AlbumDetails({
    required this.info,
    required this.cover,
    required this.tracks,
    required this.tags,
  });
}
