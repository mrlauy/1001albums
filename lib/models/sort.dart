enum Sort {
  artist,
  album,
  year,
  rating,
  ranking,
}

Sort sortFromString(String value, Sort defaultValue) => Sort.values
    .firstWhere((s) => s.toString() == value, orElse: () => defaultValue);
