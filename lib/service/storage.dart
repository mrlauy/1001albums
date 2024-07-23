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

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/1001albums/albums.csv");
  }

  Future<List<Album>> loadAlbums(bool forceReload) async {
    developer.log("load albums");
    List<List<dynamic>> storedAlbums = await _loadAlbums(forceReload);
    List<Album> albums = List<Album>(storedAlbums.length - 1);
    for (int i = 0; i < albums.length; i++) {
      albums[i] = Album.fromRow(storedAlbums[i + 1], i);
    }
    return albums;
  }

  Future<List<List<dynamic>>> _loadAlbums(bool forceReload) async {
    try {
      final file = await _localFile;
      if (forceReload || !await file.exists()) {
        developer.log("read albums from assets");
        final data = await rootBundle.loadString('assets/albums.csv');
        return readConvertor.convert(data);
      }
      developer.log("read albums from file");
      final input = file.openRead();
      return (await input
          .transform(utf8.decoder)
          .transform(readConvertor)
          .toList());
    } catch (e) {
      throw ("failed to read albums: $e");
    }
  }

  Future storeAlbums(List<Album> albums) async {
    _storeAlbums(albums.map((a) => a.toRow()).toList());
  }

  Future _storeAlbums(List<List<dynamic>> albums) async {
    developer.log("write albums to file");
    try {
      final csv = writeConvertor.convert(albums);
      final file = await _localFile;
      await file.create(recursive: true);
      await file.writeAsString('$csv');
    } catch (e) {
      print('failed to write file: $e');
    }
  }
}
