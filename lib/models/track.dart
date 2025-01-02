class Track {
  final int rank;
  final String name;
  final int? duration;

  Track(this.rank, this.name, this.duration);

  @override
  String toString() {
    return 'track $rank: [name=$name, duration=$duration]';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Track &&
        other.rank == rank &&
        other.name == name &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return rank.hashCode ^ name.hashCode ^ duration.hashCode;
  }
}
