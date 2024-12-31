import 'package:albums/models/fields.dart';
import 'package:albums/models/track.dart';

class Album {
  final int index;
  final String category;
  final String artist;
  final String albumTitle;
  final String releaseDate;
  final String rollingStoneRank;
  final String runningTime;
  final String label;
  final String producer;
  final String artDirection;
  final String nationality;

  // changeable state
  bool listened;
  double? rating;

  // loadable state
  bool details = false;
  String cover;
  List<Track> tracks;
  List<String> tags;

  Album(
    this.index,
    this.category,
    this.artist,
    this.albumTitle,
    this.releaseDate,
    this.rollingStoneRank,
    this.runningTime,
    this.label,
    this.producer,
    this.artDirection,
    this.nationality,
    this.listened,
    this.rating,
  )   : cover = "",
        tracks = List.empty(),
        tags = List.empty(),
        details = false;

  factory Album.fromRow(List<dynamic> a, int index) {
    return Album(
        index,
        a[Field.Category.index].toString(),
        a[Field.Artist.index].toString(),
        a[Field.AlbumTitle.index].toString(),
        a[Field.ReleaseDate.index].toString(),
        a[Field.RollingStoneRank.index].toString(),
        a[Field.RunningTime.index].toString(),
        a[Field.Label.index].toString(),
        a[Field.Producer.index].toString(),
        a[Field.ArtDirection.index].toString(),
        a[Field.Nationality.index].toString(),
        a[Field.Listened.index] != "",
        a[Field.Rating.index] is double
            ? a[Field.Rating.index]
            : double.tryParse(a[Field.Rating.index]) ?? null);
  }

  List<String> toRow() {
    return [
      category, // Field.Category.index
      artist, // Field.Artist.index
      albumTitle, // Field.AlbumTitle.index
      releaseDate, // Field.ReleaseDate.index
      rollingStoneRank, // Field.RollingStoneRank.index
      runningTime, // Field.RunningTime.index
      label, // Field.Label.index
      producer, // Field.Producer.index
      artDirection, // Field.ArtDirection.index
      nationality, // Field.Nationality.index
      listened ? "x" : "", // Field.Listened.index
      rating.toString(), // Field.Rating.index
    ];
  }

  @override
  String toString() {
    return "album $index: [title=$albumTitle, artist=$artist, listened=$listened, rating=$rating]";
  }

  String fullString() {
    return "album $index: [title=$albumTitle, artist=$artist, listened=$listened, rating=$rating, details=$details, tracks=$tracks, tags=$tags, cover=$cover]";
  }
}
