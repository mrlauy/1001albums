import 'package:albums/models/fields.dart';

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
  );

  factory Album.fromRow(List<dynamic> a, int index) {
    return Album(
        index,
        a[Field.category.index].toString(),
        a[Field.artist.index].toString(),
        a[Field.albumTitle.index].toString(),
        a[Field.releaseDate.index].toString(),
        a[Field.rollingStoneRank.index].toString(),
        a[Field.runningTime.index].toString(),
        a[Field.label.index].toString(),
        a[Field.producer.index].toString(),
        a[Field.artDirection.index].toString(),
        a[Field.nationality.index].toString(),
        a[Field.listened.index] != '',
        a[Field.rating.index] is double
            ? a[Field.rating.index]
            : double.tryParse(a[Field.rating.index]));
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
      listened ? 'x' : '', // Field.Listened.index
      rating.toString(), // Field.Rating.index
    ];
  }

  @override
  String toString() {
    return 'album $index: [title=$albumTitle, artist=$artist, listened=$listened, rating=$rating]';
  }
}
