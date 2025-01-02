import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:albums/models/album.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class StorageService {
  final readConvertor =
      const CsvToListConverter(fieldDelimiter: ',', eol: '\n');

  final writeConvertor =
      const ListToCsvConverter(fieldDelimiter: ',', eol: '\n');

  Future<String?> get _localPath async {
    var directory = await getExternalStorageDirectory();
    return directory?.path;
  }

  Future<File> get _localFile async {
    var path = await _localPath;
    return File('$path/1001albums/albums.csv');
  }

  Future<List<Album>> loadAlbums(bool forceReload) async {
    List<List<dynamic>> storedAlbums = await _loadAlbums(forceReload);
    List<Album> albums = storedAlbums
        .asMap()
        .map((index, albumList) =>
            MapEntry(index, Album.fromRow(albumList, index)))
        .values
        .toList(growable: false);

    return albums;
  }

  Future<List<List<dynamic>>> _loadAlbums(bool forceReload) async {
    try {
      var file = await _localFile;
      developer.log('local albums from: $file');
      if (forceReload || !await file.exists()) {
        developer.log('read albums from assets');
        var data = await rootBundle.loadString('assets/albums.csv');

        developer.log('load albums from assets : $data');
        return readConvertor.convert(data);
      }
      developer.log('read albums from file');
      var input = file.openRead();
      return (await input
          .transform(utf8.decoder)
          .transform(readConvertor)
          .toList());
    } catch (e) {
      throw ('failed to read albums: $e');
    }
  }

  Future storeAlbums(List<Album> albums) async {
    _storeAlbums(albums.map((a) => a.toRow()).toList());
  }

  Future _storeAlbums(List<List<dynamic>> albums) async {
    developer.log('write albums to file');
    try {
      var csv = writeConvertor.convert(albums);
      var file = await _localFile;
      await file.create(recursive: true);
      await file.writeAsString(csv);
    } catch (e) {
      developer.log('failed to write file: $e', error: e);
    }
  }
}
