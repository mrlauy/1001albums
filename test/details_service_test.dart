import 'package:albums/models/album.dart';
import 'package:albums/models/album_details.dart';
import 'package:albums/models/track.dart';
import 'package:albums/service/details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class FakeUri extends Fake implements Uri {}

void main() {
  group('DetailService', () {
    test('getDetails returns AlbumDetails on successful response', () async {
      var mockClient = MockClient((request) async {
        return http.Response(exampleResponse, 200,
            headers: {'Content-Type': 'application/json'});
      });

      DetailService service = DetailService(client: mockClient, apiKey: '');

      Album album = anAlbum(
        albumTitle: 'Test Album',
        artist: 'Test Artist',
      );

      AlbumDetails details = await service.getDetails(album);

      expect(details.cover,
          'https://lastfm.freetls.fastly.net/i/u/174s/3b54885952161aaea4ce2965b2db1638.png');
      expect(details.tags, ['pop', 'dance', '90s', '1998', 'cher']);
      expect(details.info,
          'Believe is the twenty-third studio album by American  singer-actress Cher.');
      expect(details.tracks.length, 10);
      expect(details.tracks[0], equals(Track(1, 'Believe', 237)));
      expect(details.tracks[1], equals(Track(2, 'The Power', 234)));
      expect(details.tracks[2], equals(Track(3, 'Runaway', 281)));
    });

    test('getDetails throws an exception on failed response', () async {
      MockClient mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      DetailService service = DetailService(client: mockClient, apiKey: '');

      Album album = anAlbum(
        albumTitle: 'Test Album',
        artist: 'Test Artist',
      );

      expect(() => service.getDetails(album), throwsException);
    });

    test('extracts data correctly when some values are missing', () async {
      var mockClient = MockClient((request) async {
        return http.Response(partialResponse, 200,
            headers: {'Content-Type': 'application/json'});
      });

      DetailService service = DetailService(client: mockClient, apiKey: '');

      Album album = anAlbum(
        albumTitle: 'Test Album',
        artist: 'Test Artist',
      );

      AlbumDetails details = await service.getDetails(album);

      expect(details.cover, isNull);
      expect(details.tags, ['pop']);
      expect(details.info, isNull);
      expect(details.tracks.length, 1);
      expect(details.tracks[0], equals(Track(1, 'Believe', null)));
    });

    test('extracts data correctly when there are no tags', () async {
      var mockClient = MockClient((request) async {
        return http.Response(emptyTagsResponse, 200,
            headers: {'Content-Type': 'application/json'});
      });

      DetailService service = DetailService(client: mockClient, apiKey: '');

      Album album = anAlbum(
        albumTitle: 'Test Album',
        artist: 'Test Artist',
      );

      AlbumDetails details = await service.getDetails(album);

      expect(details.cover, isNull);
      expect(details.tags, []);
      expect(details.tracks.length, 0);
    });

    test('extracts data correctly when all values are missing', () async {
      var mockClient = MockClient((request) async {
        return http.Response(emptyResponse, 200,
            headers: {'Content-Type': 'application/json'});
      });

      DetailService service = DetailService(client: mockClient, apiKey: '');

      Album album = anAlbum(
        albumTitle: 'Test Album',
        artist: 'Test Artist',
      );

      AlbumDetails details = await service.getDetails(album);

      expect(details.cover, isNull);
      expect(details.tags, isEmpty);
      expect(details.info, isNull);
      expect(details.tracks, isEmpty);
    });
  });
}

Album anAlbum({
  String artist = 'U2',
  String albumTitle = "All That You Can't Leave Behind",
}) {
  return Album(
    1,
    'Both lists',
    artist,
    albumTitle,
    '2000',
    '139',
    '53:12:52',
    'Island',
    'Brian Eno / Daniel Lanois',
    'Steve Averill',
    'Ireland / UK',
    false,
    null,
  );
}

String exampleResponse = '''
{
  "album": {
    "artist": "Cher",
    "mbid": "03c91c40-49a6-44a7-90e7-a700edf97a62",
    "tags": {
      "tag": [
        {
          "url": "https://www.last.fm/tag/pop",
          "name": "pop"
        },
        {
          "url": "https://www.last.fm/tag/dance",
          "name": "dance"
        },
        {
          "url": "https://www.last.fm/tag/90s",
          "name": "90s"
        },
        {
          "url": "https://www.last.fm/tag/1998",
          "name": "1998"
        },
        {
          "url": "https://www.last.fm/tag/cher",
          "name": "cher"
        }
      ]
    },
    "playcount": "6387579",
    "image": [
      {
        "size": "small",
        "#text": "https://lastfm.freetls.fastly.net/i/u/34s/3b54885952161aaea4ce2965b2db1638.png"
      },
      {
        "size": "medium",
        "#text": "https://lastfm.freetls.fastly.net/i/u/64s/3b54885952161aaea4ce2965b2db1638.png"
      },
      {
        "size": "large",
        "#text": "https://lastfm.freetls.fastly.net/i/u/174s/3b54885952161aaea4ce2965b2db1638.png"
      },
      {
        "size": "extralarge",
        "#text": "https://lastfm.freetls.fastly.net/i/u/300x300/3b54885952161aaea4ce2965b2db1638.png"
      },
      {
        "size": "mega",
        "#text": "https://lastfm.freetls.fastly.net/i/u/300x300/3b54885952161aaea4ce2965b2db1638.png"
      },
      {
        "size": "",
        "#text": "https://lastfm.freetls.fastly.net/i/u/300x300/3b54885952161aaea4ce2965b2db1638.png"
      }
    ],
    "tracks": {
      "track": [
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 237,
          "url": "https://www.last.fm/music/Cher/Believe/Believe",
          "name": "Believe",
          "@attr": {
            "rank": 1
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        },
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 234,
          "url": "https://www.last.fm/music/Cher/Believe/The+Power",
          "name": "The Power",
          "@attr": {
            "rank": 2
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        },
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 281,
          "url": "https://www.last.fm/music/Cher/Believe/Runaway",
          "name": "Runaway",
          "@attr": {
            "rank": 3
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        },
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 236,
          "url": "https://www.last.fm/music/Cher/Believe/All+or+Nothing",
          "name": "All or Nothing",
          "@attr": {
            "rank": 4
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        },
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 221,
          "url": "https://www.last.fm/music/Cher/Believe/Strong+Enough",
          "name": "Strong Enough",
          "@attr": {
            "rank": 5
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        },
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 255,
          "url": "https://www.last.fm/music/Cher/Believe/Dov%27e+L%27amore",
          "name": "Dov'e L'amore",
          "@attr": {
            "rank": 6
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        },
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 269,
          "url": "https://www.last.fm/music/Cher/Believe/Takin%27+Back+My+Heart",
          "name": "Takin' Back My Heart",
          "@attr": {
            "rank": 7
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        },
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 296,
          "url": "https://www.last.fm/music/Cher/Believe/Taxi+Taxi",
          "name": "Taxi Taxi",
          "@attr": {
            "rank": 8
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        },
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 268,
          "url": "https://www.last.fm/music/Cher/Believe/Love+Is+the+Groove",
          "name": "Love Is the Groove",
          "@attr": {
            "rank": 9
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        },
        {
          "streamable": {
            "fulltrack": "0",
            "#text": "0"
          },
          "duration": 307,
          "url": "https://www.last.fm/music/Cher/Believe/We+All+Sleep+Alone",
          "name": "We All Sleep Alone",
          "@attr": {
            "rank": 10
          },
          "artist": {
            "url": "https://www.last.fm/music/Cher",
            "name": "Cher",
            "mbid": "bfcc6d75-a6a5-4bc6-8282-47aec8531818"
          }
        }
      ]
    },
    "url": "https://www.last.fm/music/Cher/Believe",
    "name": "Believe",
    "listeners": "819380",
    "wiki": {
      "published": "06 Jun 2023, 00:31",
      "summary": "Believe is the twenty-third studio album by American singer-actress Cher.",
      "content": "Believe is the twenty-third studio album by American  singer-actress Cher."
    }
  }
}
''';

String partialResponse = '''
{
  "album": {
    "artist": "Cher",
    "tags": {
      "tag": [
        {
          "name": "pop"
        }
      ]
    },
    "tracks": {
      "track": [
        {
          "name": "Believe",
          "@attr": {
            "rank": 1
          }
        }
      ]
    }
  }
}
''';

String emptyTagsResponse = '''
{
   "album":{
      "artist":"Billy Bragg/Wilco",
      "listeners":"36",
      "image":[
         {
            "size":"small",
            "#text":""
         },
         {
            "size":"medium",
            "#text":""
         }
      ],
      "mbid":"0491813b-1bad-3340-84af-278d44db4f0d",
      "tags":"",
      "name":"Mermaid Avenue",
      "playcount":"290",
      "url":"https://www.last.fm/music/+noredirect/Billy+Bragg%2FWilco/Mermaid+Avenue"
   }
}
''';

String emptyResponse = '''
{
  "album": {
    "artist": "Cher"
  }
}
''';
