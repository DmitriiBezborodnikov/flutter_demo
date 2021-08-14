import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ImagePage.dart';
import 'ImagesStorage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.storage}) : super(key: key);

  final ImagesStorage storage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List a = [];

  bool _hasMore = true;
  int _pageNumber = 1;
  bool _error = false;
  bool _loading = true;
  final int _defaultPhotosPerPageCount = 10;
  List _photos = [];
  final int _nextPageThreshold = 2;

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _photos = [];
    widget.storage.readImages().then((List value) {
      setState(() {
        a = value;
        fetchPhotos();
      });
    });
  }

  FutureOr onGoBack(dynamic value) {
    if (value == true) {
      _hasMore = true;
      _pageNumber = 1;
      _error = false;
      _loading = true;
      _photos = [];
      widget.storage.readImages().then((List images) {
        a = images;
        setState(() {
          fetchPhotos();
        });
      });
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('phone');

                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Future<void> fetchPhotos() async {
      final startIndex = (_pageNumber - 1) * _defaultPhotosPerPageCount;
      final endIndex = startIndex + _defaultPhotosPerPageCount;
      List fetchedPhotos = [];
      if (startIndex < a.length) {
        await new Future.delayed(new Duration(seconds: 2), () {
          fetchedPhotos.addAll(a.getRange(startIndex, endIndex < a.length ? endIndex : a.length));
        });
      }
      if (mounted) {
        setState(() {
          _hasMore = endIndex < a.length;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _photos.addAll(fetchedPhotos);
        });
      }
  }

  Widget getBody() {
    if (_photos.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ));
      } else if (_error) {
        return Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  fetchPhotos();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Error while loading photos, tap to try again"),
              ),
            ));
      }
    } else {
      return ListView.builder(
          itemCount: _photos.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _photos.length - _nextPageThreshold) {
              fetchPhotos();
            }
            if (index == _photos.length) {
              if (_error) {
                return Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _loading = true;
                          _error = false;
                          fetchPhotos();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("Error while loading photos, tap to try again"),
                      ),
                    ));
              } else {
                return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ));
              }
            }
            final photo = _photos[index];
            return Card(
              child: InkWell(
                onTap: () {
                  // Function is executed on tap.
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          new ImagePage(photo: photo, storage: widget.storage,)))
                  .then(onGoBack);
                },
                child: Column(
                  children: <Widget>[
                    Image.network(
                      photo,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      height: 160,
                    ),
                  ],
                ),
              ),
            );
          });
    }
    return Container();
  }
}

