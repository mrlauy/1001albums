import 'dart:convert';
import 'dart:developer' as developer;

import 'package:albums/models/album.dart';
import 'package:albums/models/album_details.dart';
import 'package:albums/models/track.dart';
import 'package:http/http.dart';

class DetailService {
  final String apiKey;
  final Client client;

  const DetailService({required this.client, required this.apiKey});

  Future<AlbumDetails> getDetails(Album album) async {
    developer.log('retrieving album: ${album.albumTitle}');

    var url = Uri.parse(
        'https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=$apiKey&artist=${album.artist}&album=${album.albumTitle}&format=json');
    Response response = await client.get(url);
    if (response.statusCode == 200) {
      try {
        developer.log('response: ${response.body}');
        var data = jsonDecode(response.body);

        var albumData = data['album'];
        var info = extractInfo(albumData['wiki']);
        var cover = extractCover(albumData['image']);
        List<String> tags = extractTags(albumData['tags']);
        List<Track> tracks = extractTracks(albumData['tracks']);

        developer.log('album details: $cover, $tags, $tracks');
        return AlbumDetails(
          info: info,
          cover: cover,
          tags: tags,
          tracks: tracks,
        );
      } catch (e, stackTrace) {
        developer.log('Failed to parse album details: $e', error: e);
        throw Error.throwWithStackTrace(
            Exception('Failed to parse album details: $e'), stackTrace);
      }
    } else {
      throw Exception('Failed to get album details');
    }
  }

  String? extractInfo(dynamic wikiData) {
    if (wikiData == null || wikiData.isEmpty || wikiData['content'] == null) {
      return null;
    }

    return wikiData['content'];
  }

  String? extractCover(dynamic imageData) {
    if (imageData == null || imageData.isEmpty) {
      return null;
    }

    String cover =
        imageData.length > 2 ? imageData[2]['#text'] : imageData[0]['#text'];

    if (!cover.startsWith('http') || !cover.startsWith('https')) {
      return null;
    }
    return cover;
  }

  List<String> extractTags(dynamic tagsData) {
    if (tagsData == null || tagsData.isEmpty) {
      return [];
    }

    return tagsData?['tag']
            ?.map<String>((tag) => '${tag['name']}')
            .where((name) => name != '')
            .toList() ??
        [];
  }

  List<Track> extractTracks(dynamic tracksData) {
    Iterable<Track?> tracks = tracksData?['track']?.map<Track?>((track) =>
            track['name'] != null && track['name'] != ''
                ? Track(
                    int.tryParse(track['@attr']?['rank']?.toString() ?? '0') ??
                        0,
                    track['name'] ?? '',
                    track['duration'])
                : null) ??
        [];

    return tracks.nonNulls.toList();
  }
}
