import 'package:flutter/foundation.dart';

enum Sort {
  Artist,
  Album,
  Year,
  Rating,
  Ranking,
}

extension EnumExt on Sort {
  String get text => describeEnum(this);

}
Sort sortFromString(String value, Sort defaultValue) =>  Sort.values.firstWhere((s) => s.toString() == value, orElse: () => defaultValue);

