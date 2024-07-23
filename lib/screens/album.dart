import 'dart:developer' as developer;

import 'package:albums/models/album.dart';
import 'package:albums/models/track.dart';
import 'package:albums/screens/loading.dart';
import 'package:albums/service/details.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AlbumPage extends StatefulWidget {
  final Album album;
  final Function(Album) updateAlbum;

  const AlbumPage({Key key, this.album, this.updateAlbum}) : super(key: key);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final _detailsService = DetailService();

  Album _album;

  @override
  void initState() {
    super.initState();
    _album = widget.album;
    if (!_album.details) {
      _detailsService.getDetails(_album).then((value) {
        setState(() => _album = value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    developer.log("build details: ${_album.fullString()}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: _album.cover == null || !_album.cover.startsWith("http")
                  ? Image.asset('images/ic_album.png', height: 12)
                  : FadeInImage.assetNetwork(
                      placeholder: 'images/ic_album.png',
                      image: _album.cover,
                    ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Text(
                _album.albumTitle,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _album.artist,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Divider(),
            CheckboxListTile(
              title: Text('Listened to album'),
              value: _album.listened,
              onChanged: (value) {
                setState(() => _album.listened = value);
                widget.updateAlbum(_album);
              },
            ),
            infoRow('Category', _album.category),
            if (_album.rollingStoneRank.isNotEmpty)
              infoRow('Rolling stone rank', _album.rollingStoneRank),
            if (_album.releaseDate.isNotEmpty)
              infoRow('Release date', _album.releaseDate),
            if (_album.runningTime.isNotEmpty)
              infoRow('Running Time', _album.runningTime),
            if (_album.producer.isNotEmpty)
              infoRow('Producer', _album.producer),
            if (_album.label.isNotEmpty) infoRow('Label', _album.label),
            if (_album.artDirection.isNotEmpty)
              infoRow('Art direction', _album.artDirection),
            Divider(),
            Center(
              child: SmoothStarRating(
                rating: _album.rating ?? -1,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                starCount: 5,
                allowHalfRating: true,
                spacing: 2.0,
                onRated: (value) {
                  setState(() => _album.rating = value);
                  widget.updateAlbum(_album);
                },
              ),
            ),
            Divider(),
            detailsView(),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String info, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(info)),
          Expanded(flex: 2, child: Text(value)),
        ],
      ),
    );
  }

  Widget detailsView() {
    return !_album.details
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: LoadingView(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('tags: ${_album.tags.join(", ")}'),
              ),
              Divider(),
              for (var track in _album.tracks) trackRow(track),
            ],
          );
  }

  Widget trackRow(Track track) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('${track.rank}')),
          Expanded(flex: 6, child: Text(track.name)),
          Expanded(flex: 1, child: Text(track.duration)),
        ],
      ),
    );
  }
}
