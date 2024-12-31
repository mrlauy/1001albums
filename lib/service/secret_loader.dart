import 'dart:async' show Future;
import 'dart:convert' show json;

import 'package:albums/models/secret.dart';
import 'package:flutter/services.dart' show rootBundle;

class SecretLoader {

  static const _secretPath = 'secrets.json';

  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(_secretPath,
        (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
