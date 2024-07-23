import 'package:albums/models/fields.dart';

class Track {
  final int rank;
  final String name;
  final String duration;

  Track(this.rank, this.name, this.duration);

  @override
  String toString() {
  return "track $rank: [name=$name, duration=$duration]";
  }
}
