import 'package:albums/models/album.dart';
import 'package:albums/models/track.dart';
import 'package:albums/widgets/star_rating.dart';
import 'package:flutter/material.dart';

class AlbumPage extends StatefulWidget {
  final Album album;
  final Function(Album, bool) updateListened;
  final Function(Album, double) updateRating;

  AlbumPage({
    required this.album,
    required this.updateListened,
    required this.updateRating,
  });

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late bool _listened;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _listened = widget.album.listened;
    _rating = widget.album.rating ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: !widget.album.cover.startsWith("http")
                  ? Image.asset('images/ic_album.png', height: 12)
                  : FadeInImage.assetNetwork(
                      placeholder: 'images/ic_album.png',
                      image: widget.album.cover,
                    ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Text(
                widget.album.albumTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.album.artist,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Divider(),
            CheckboxListTile(
              title: Text('Listened to album',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: _listened,
              onChanged: (value) {
                setState(() {
                  _listened = !_listened;
                });
                widget.updateListened(widget.album, _listened);
              },
            ),
            infoRow('Category', widget.album.category),
            if (widget.album.rollingStoneRank.isNotEmpty)
              infoRow('Rolling stone rank', widget.album.rollingStoneRank),
            if (widget.album.releaseDate.isNotEmpty)
              infoRow('Release date', widget.album.releaseDate),
            if (widget.album.runningTime.isNotEmpty)
              infoRow('Running Time', widget.album.runningTime),
            if (widget.album.producer.isNotEmpty)
              infoRow('Producer', widget.album.producer),
            if (widget.album.label.isNotEmpty)
              infoRow('Label', widget.album.label),
            if (widget.album.artDirection.isNotEmpty)
              infoRow('Art direction', widget.album.artDirection),
            Divider(),
            Center(
              child: StarRating(
                rating: _rating,
                size: 40,
                onRatingChange: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                  widget.updateRating(widget.album, rating);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(info, style: Theme.of(context).textTheme.bodyMedium)),
          Expanded(
              flex: 2,
              child:
                  Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget detailsView() {
    return !widget.album.details
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('tags: ${widget.album.tags.join(", ")}'),
              ),
              Divider(),
              for (var track in widget.album.tracks) trackRow(track),
            ],
          );
  }

  Widget trackRow(Track track) {
    return Padding(
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
