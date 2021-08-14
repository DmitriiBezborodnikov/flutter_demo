import 'package:flutter/material.dart';

import 'ImagesStorage.dart';

class ImagePage extends StatelessWidget {
  final String photo;
  final ImagesStorage storage;
  bool _load = false;

  ImagePage({
    required this.photo,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Image Screen'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  _load = true;
                  new Future.delayed(new Duration(seconds: 2), () async {
                    await storage.removeImage(photo);

                    Navigator.of(context).pop(true);
                    _load = false;
                  });
                },
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Stack(
        children: [
          new Image.network(
            photo,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Visibility(
            visible: _load,
            child: new Align(
              child: new Container(
                color: Colors.grey[300],
                width: 70.0,
                height: 70.0,
                child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Center(child: new CircularProgressIndicator())),
              ),
              alignment: FractionalOffset.center,
            ),
          )
        ],
      ),
    );
  }
}
