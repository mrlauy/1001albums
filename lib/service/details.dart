import 'dart:developer' as developer;

import 'package:albums/models/album.dart';
// import 'package:scrobblenaut/lastfm.dart' as lastfm;
// import 'package:scrobblenaut/scrobblenaut.dart';

class DetailService {
  // static LastFM _lastFMAuth;

  static final DetailService _instance = DetailService._internal();

  factory DetailService() => _instance;

  DetailService._internal() {
    developer.log("create details service");
  }

  // static Future<LastFM> init() async {
  //   developer.log("init details service");
  //   final secrets = await SecretLoader().load();
  //   _lastFMAuth = LastFM.noAuth(apiKey: secrets.apiKey);
  //   return _lastFMAuth;
  // }
  //
  // Future<LastFM> get lastFMAuth async {
  //   return _lastFMAuth ?? init();
  // }

  Future<Album> getDetails(Album album) async {
    developer.log("retrieving album: ${album.albumTitle}");

    // final lastFMAuth = await _instance.lastFMAuth;
    // final scrobblenaut = Scrobblenaut(lastFM: lastFMAuth);

    // var info = await scrobblenaut.album
    //     .getInfo(album: album.albumTitle, artist: album.artist);

    album.details = false;
    // album.cover = image(info.images ?? [])?.text;
    // album.tags = info.tags?.map((t) => t.name)?.toList();
    // album.tracks = List<Track>(info.tracks.length);
    // for (var i = 0; i < info.tracks.length; ++i) {
    //   final track = info.tracks[i];
    //   album.tracks[i] = Track(i, track.name, format(track.duration));
    // }

    developer.log("album details: ${album.fullString()}");

    return album;
  }

  format(Duration d) => d.toString().substring(d.inHours > 0 ? 0 : 2, 7);

/*  static const List<lastfm.Size> sizePriority = [
    lastfm.Size.large,
    lastfm.Size.medium,
    lastfm.Size.extralarge,
    lastfm.Size.small,
    lastfm.Size.mega,
    lastfm.Size.empty,
    lastfm.Size.None,
  ];

  image(List<lastfm.Image> images) {
    images.sort((i1, i2) =>
        sizePriority.indexOf(i1.size).compareTo(sizePriority.indexOf(i2.size)));
    return images.first;
  }*/
}
