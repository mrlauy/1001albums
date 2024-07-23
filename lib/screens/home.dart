import 'dart:developer' as developer;

import 'package:albums/models/album.dart';
import 'package:albums/models/settings.dart';
import 'package:albums/models/sort.dart';
import 'package:albums/screens/about.dart';
import 'package:albums/screens/albums.dart';
import 'package:albums/screens/loading.dart';
import 'package:albums/service/storage.dart';
import 'package:alphanum_comparator/alphanum_comparator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

const CONTENT_VERSION = 1;
const CONTENT_VERSION_SETTING = "content_version";
const PREFERENCE_SORT = "sort";
const PREFERENCE_DIRECTION = "sort_direction";
const PREFERENCE_LISTENED = "show_listened";
const PREFERENCE_1001ALBUMS = "show_1001Albums";
const PREFERENCE_ROLLING_STONES = "show_rolling_stones";

class _HomePageState extends State<HomePage> {
  final StorageService albumStorage = StorageService();

  List<Album> _albums;
  Iterable<Album> _displayedAlbums;
  Settings _settings;

  @override
  void initState() {
    super.initState();
    developer.log('init 1001Albums');


    SharedPreferences.getInstance().then((prefs) {
      setState(() =>
      _settings = Settings(
        prefs.getInt(CONTENT_VERSION_SETTING) ?? 0,
        sortFromString(prefs.getString(PREFERENCE_SORT), Sort.Album),
        prefs.getBool(PREFERENCE_DIRECTION) ?? true,
        prefs.getBool(PREFERENCE_LISTENED) ?? true,
        prefs.getBool(PREFERENCE_1001ALBUMS) ?? true,
        prefs.getBool(PREFERENCE_ROLLING_STONES) ?? true,
      ));

      developer.log("init state: $_settings");

      albumStorage
          .loadAlbums(_settings.contentVersion < CONTENT_VERSION)
          .then((value) {
            prefs.setInt(CONTENT_VERSION_SETTING, CONTENT_VERSION);
            setState(() => _albums = value);
          })
          .catchError((err) => print("TODO show error: $err"));
    });
  }

  @override
  Widget build(BuildContext context) {
    developer.log("build albums list");

    return Scaffold(
      appBar: AppBar(
        title: Text('1001 Albums'),
      ),
      body: _displayedAlbums == null
          ? LoadingView()
          : AlbumsView(
        albums: _displayedAlbums,
        updateAlbum: setAlbum,
        sorting: _settings.sort,
      ),
      drawer: _menuDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_list),
        onPressed: filterMenu,
      ),
    );
  }

  void filterMenu() {
    if (_settings != null) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Column(
            children: <Widget>[
              ListTile(
                title: const Text('Sort albums by'),
                trailing: DropdownButton<Sort>(
                  value: _settings.sort,
                  onChanged: (Sort value) {
                    setState(() => _settings.sort = value);
                    saveSetting((prefs) =>
                        prefs.setString(PREFERENCE_SORT, value.toString()));
                    Navigator.pop(context);
                  },
                  items: Sort.values.map<DropdownMenuItem<Sort>>((Sort value) {
                    return DropdownMenuItem<Sort>(
                      value: value,
                      child: Text(value.text),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: Text('Sort albums ascending'),
                trailing: Switch(
                  value: _settings.sortAscending,
                  onChanged: (checked) {
                    setState(() => _settings.sortAscending = checked);
                    saveSetting((prefs) =>
                        prefs.setBool(PREFERENCE_DIRECTION, checked));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Show listened'),
                trailing: Switch(
                  value: _settings.showListened,
                  onChanged: (checked) {
                    setState(() => _settings.showListened = checked);
                    saveSetting(
                            (prefs) =>
                            prefs.setBool(PREFERENCE_LISTENED, checked));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Show only in 1001 Albums'),
                trailing: Switch(
                  value: _settings.show1001Albums,
                  onChanged: (checked) {
                    setState(() => _settings.show1001Albums = checked);
                    saveSetting((prefs) =>
                        prefs.setBool(PREFERENCE_1001ALBUMS, checked));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Show only in Rolling Stone 500'),
                trailing: Switch(
                  value: _settings.showRollingStones,
                  onChanged: (checked) {
                    setState(() => _settings.showRollingStones = checked);
                    saveSetting((prefs) =>
                        prefs.setBool(PREFERENCE_ROLLING_STONES, checked));
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void saveSetting(Function(SharedPreferences) save) async {
    SharedPreferences.getInstance().then((prefs) {
      save(prefs);
    });
  }

  @override
  void setState(VoidCallback fn) {
    developer.log("update state");
    super.setState(fn);
    _displayedAlbums = listAlbums();
  }

  void setAlbum(Album album) {
    developer.log("update ${_albums[album.index]} -> $album");
    setState(() => _albums[album.index] = album);
    albumStorage.storeAlbums(_albums);
  }

  Iterable<Album> listAlbums() {
    if (_albums == null || _settings == null) {
      return null;
    }

    developer.log("list albums: $_settings");
    List<Album> albums = _albums
        .where((album) =>
    (_settings.showListened || !album.listened) &&
        (_settings.show1001Albums || album.category != "1001... Only") &&
        (_settings.showRollingStones ||
            !album.category.startsWith("RS 500")))
        .toList();

    // sort the albums
    switch (_settings.sort) {
      case Sort.Artist:
        albums.sort((a, b) => a.artist.compareTo(b.artist));
        break;
      case Sort.Album:
        albums.sort((a, b) => a.albumTitle.compareTo(b.albumTitle));
        break;
      case Sort.Year:
        albums.sort((a, b) => _stringComparator(a.releaseDate, b.releaseDate));
        break;
      case Sort.Rating:
        albums.sort((a, b) => _doubleComparator(a.rating, b.rating));
        break;
      case Sort.Ranking:
        albums.sort((a, b) =>
            _stringComparator(a.rollingStoneRank, b.rollingStoneRank));
        break;
    }
    return _settings.sortAscending ? albums : albums.reversed;
  }

  Drawer _menuDrawer(BuildContext context) {
    final headerChild = DrawerHeader(
      decoration: BoxDecoration(color: Theme
          .of(context)
          .primaryColor),
      child: Text(
        '',
        style:
        Theme
            .of(context)
            .textTheme
            .headline5
            .copyWith(color: Colors.white),
      ),
    );

    return Drawer(
      child: ListView(
        children: [
          headerChild,
          _menuItem(Icons.info, "About", AboutPage.routeName),
          Divider(),
        ],
      ),
    );
  }

  ListTile _menuItem(var icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // pop closes the drawer
        Navigator.of(context).pop();
        // navigate to the route
        Navigator.of(context).pushNamed(routeName);
      },
    );
  }

  int _stringComparator(String a, String b) {
    var aRank = a.isNotEmpty && a != "--" ? a : (_settings.sortAscending ? "9999" : "-1");
    var bRank = b.isNotEmpty && b != "--" ? b : (_settings.sortAscending ? "9999" : "-1");
    return AlphanumComparator.compare(aRank, bRank);
  }

  int _doubleComparator(double a, double b) {
    var aRank = a?? (_settings.sortAscending ? 9999 : -1);
    var bRank = b?? (_settings.sortAscending ? 9999 : -1);
    return aRank.compareTo(bRank);
  }
}
