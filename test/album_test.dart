import 'package:albums/models/album.dart';
import 'package:albums/screens/album.dart';
import 'package:albums/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Album Page Tests', () {
    testWidgets('Should render', (tester) async {
      Album album = anAlbum(
        category: 'RS 500 compilations',
        artist: 'Muddy Waters',
      );

      await tester.pumpWidget(MaterialApp(
        home: AlbumPage(
            album: album,
            updateListened: (Album album, bool listened) {},
            updateRating: (Album album, double rating) {}),
      ));

      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Muddy Waters'), findsOneWidget);
      expect(find.text('RS 500 compilations'), findsOneWidget);
    });

    testWidgets('Should change and callback listened', (tester) async {
      bool listenedClicked = false;

      Album album = anAlbum(listened: true);

      await tester.pumpWidget(MaterialApp(
        home: AlbumPage(
            album: album,
            updateListened: (Album album, bool listened) {
              listenedClicked = true;
            },
            updateRating: (Album album, double rating) {}),
      ));

      var checkBoxFinder = find.byType(Checkbox);

      expect(tester.widget<Checkbox>(checkBoxFinder).value, true);

      await tester.tap(checkBoxFinder);
      await tester.pump();

      expect(tester.widget<Checkbox>(checkBoxFinder).value, false);

      expect(listenedClicked, true);
    });

    testWidgets('Should change and callback listened', (tester) async {
      double ratingClicked = 0;

      Album album = anAlbum(rating: null);

      await tester.pumpWidget(MaterialApp(
        home: AlbumPage(
            album: album,
            updateListened: (Album album, bool listened) {},
            updateRating: (Album album, double rating) {
              ratingClicked = rating;
            }),
      ));

      expect(find.byType(StarRating), findsOneWidget);
      expect(find.byType(Icon), findsNWidgets(5));

      var emptyStarFinder = find.byIcon(Icons.star_border);
      var halfStarFinder = find.byIcon(Icons.star_half);
      var fullStarFinder = find.byIcon(Icons.star);

      expect(emptyStarFinder, findsNWidgets(5));
      expect(halfStarFinder, findsNothing);
      expect(fullStarFinder, findsNothing);

      await tester.tapAt(tester.getCenter(find.byType(StarRating)));
      await tester.pump();

      expect(emptyStarFinder, findsNWidgets(2));
      expect(halfStarFinder, findsNothing);
      expect(fullStarFinder, findsNWidgets(3));

      expect(ratingClicked, 3.0);
    });
  });
}

Album anAlbum({
  String category = 'Both lists',
  String artist = 'U2',
  bool listened = false,
  double? rating,
}) {
  return Album(
    1,
    category,
    artist,
    "All That You Can't Leave Behind",
    '2000',
    '139',
    '53:12:52',
    'Island',
    'Brian Eno / Daniel Lanois',
    'Steve Averill',
    'Ireland / UK',
    listened,
    rating,
  );
}
