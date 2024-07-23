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
  double rating;

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
      this.rating);

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
        a[Field.Rating.index] is double ? a[Field.Rating.index] : double.tryParse(a[Field.Rating.index]) ?? null
    );
  }

  List<String> toRow() {
    List<String> row = List<String>(Field.values.length);
    row[Field.Category.index] = category;
    row[Field.Artist.index] = artist;
    row[Field.AlbumTitle.index] = albumTitle;
    row[Field.ReleaseDate.index] = releaseDate;
    row[Field.RollingStoneRank.index] = rollingStoneRank;
    row[Field.RunningTime.index] = runningTime;
    row[Field.Label.index] = label;
    row[Field.Producer.index] = producer;
    row[Field.ArtDirection.index] = artDirection;
    row[Field.Nationality.index] = nationality;
    row[Field.Listened.index] = listened ? "x" : "";
    row[Field.Rating.index] = rating?.toString();
    return row;
  }

  @override
  String toString() {
    return "album $index: [title=$albumTitle, artist=$artist, listened=$listened, rating=$rating]";
  }

  String fullString() {
    return "album $index: [title=$albumTitle, artist=$artist, listened=$listened, rating=$rating, details=$details, tracks=$tracks, tags=$tags, cover=$cover]";
  }
}
