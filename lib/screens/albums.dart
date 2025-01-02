import 'package:albums/models/album.dart';
import 'package:albums/models/sort.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import 'album.dart';

class AlbumsView extends StatelessWidget {
  final Iterable<Album> albums;
  final Function(Album, bool) updateListened;
  final Function(Album, double) updateRating;
  final Sort sorting;
  final ScrollController _controller = ScrollController();

  AlbumsView({
    super.key,
    required this.albums,
    required this.updateListened,
    required this.updateRating,
    required this.sorting,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollbar.semicircle(
      labelTextBuilder: (offset) {
        if (!_controller.hasClients) {
          return const Text('');
        }
        int currentIndex = (_controller.offset /
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
            title: Text(albums.elementAt(index).albumTitle),
            subtitle: Text(albums.elementAt(index).artist),
            leading: Checkbox(
              visualDensity: VisualDensity.compact,
              value: albums.elementAt(index).listened,
              onChanged: (checked) {
                updateListened(albums.elementAt(index), checked ?? false);
              },
            ),
            visualDensity: VisualDensity.compact,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            onTap: () => _navigateAlbum(context, albums.elementAt(index)),
          );
        },
      ),
    );
  }

  void _navigateAlbum(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlbumPage(
          album: album,
          updateListened: updateListened,
          updateRating: updateRating,
        ),
      ),
    );
  }

  String _scrollHint(int currentIndex) {
    switch (sorting) {
      case Sort.artist:
        return albums.elementAt(currentIndex).artist.substring(0, 1);
      case Sort.year:
        var year = albums.elementAt(currentIndex).releaseDate;
        return year.isNotEmpty ? year : '--';
      case Sort.rating:
        return '${albums.elementAt(currentIndex).rating}';
      case Sort.ranking:
        var stoneRank = albums.elementAt(currentIndex).rollingStoneRank;
        return stoneRank.isNotEmpty ? stoneRank : '--';
      case Sort.album:
        return albums.elementAt(currentIndex).albumTitle.substring(0, 1);
    }
  }
}
