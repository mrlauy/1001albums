import 'package:albums/models/album.dart';
import 'package:albums/models/sort.dart';
import 'package:albums/screens/album.dart';
import "package:draggable_scrollbar/draggable_scrollbar.dart";
import 'package:flutter/material.dart';

class AlbumsView extends StatelessWidget {
  final Iterable<Album> albums;
  final Function(Album) updateAlbum;
  final Sort sorting;

  const AlbumsView({Key key, this.albums, this.updateAlbum, this.sorting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    return DraggableScrollbar.semicircle(
      labelTextBuilder: (offset) {
        if (!_controller.hasClients) {
          return Text("");
        }
        final int currentIndex = (_controller.offset /
                _controller.position.maxScrollExtent *
                (albums.length - 1))
            .floor();
        return Text(_scrollHint(currentIndex));
      },
      controller: _controller,
      child: ListView.builder(
        controller: _controller,
        itemCount: albums.length,
        itemExtent: 65,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${albums.elementAt(index).albumTitle}'),
            subtitle: Text('${albums.elementAt(index).artist}'),
            leading: Checkbox(
              visualDensity: VisualDensity.compact,
              value: albums.elementAt(index).listened,
              onChanged: (checked) {
                albums.elementAt(index).listened = checked;
                updateAlbum(albums.elementAt(index));
              },
            ),
            visualDensity: VisualDensity.compact,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => AlbumPage(
                      album: albums.elementAt(index), updateAlbum: updateAlbum),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _scrollHint(int currentIndex) {
    switch (sorting) {
      case Sort.Artist:
        return albums.elementAt(currentIndex).artist.substring(0, 1);
      case Sort.Year:
        final year = albums.elementAt(currentIndex).releaseDate;
        return year.isNotEmpty ? year : "--";
      case Sort.Rating:
        return "${albums.elementAt(currentIndex).rating??"--"}";
      case Sort.Ranking:
        final stoneRank = albums.elementAt(currentIndex).rollingStoneRank;
        return stoneRank.isNotEmpty ? stoneRank : "--";
      case Sort.Album:
      default:
        return albums.elementAt(currentIndex).albumTitle.substring(0, 1);
    }
  }
}
