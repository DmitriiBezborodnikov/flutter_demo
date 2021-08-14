import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImagesStorage {
  List defaults = [
    "https://dummyimage.com/600x400/000/fff&text=1",
    "https://dummyimage.com/600x400/000/fff&text=2",
    "https://dummyimage.com/600x400/000/fff&text=3",
    "https://dummyimage.com/600x400/000/fff&text=4",
    "https://dummyimage.com/600x400/000/fff&text=5",
    "https://dummyimage.com/600x400/000/fff&text=6",
    "https://dummyimage.com/600x400/000/fff&text=7",
    "https://dummyimage.com/600x400/000/fff&text=8",
    "https://dummyimage.com/600x400/000/fff&text=9",
    "https://dummyimage.com/600x400/000/fff&text=10",
    "https://dummyimage.com/600x400/000/fff&text=11",
    "https://dummyimage.com/600x400/000/fff&text=12",
    "https://dummyimage.com/600x400/000/fff&text=13",
    "https://dummyimage.com/600x400/000/fff&text=14",
    "https://dummyimage.com/600x400/000/fff&text=15",
    "https://dummyimage.com/600x400/000/fff&text=16",
    "https://dummyimage.com/600x400/000/fff&text=17",
    "https://dummyimage.com/600x400/000/fff&text=18",
    "https://dummyimage.com/600x400/000/fff&text=19",
    "https://dummyimage.com/600x400/000/fff&text=20",
    "https://dummyimage.com/600x400/000/fff&text=21",
    "https://dummyimage.com/600x400/000/fff&text=22",
    "https://dummyimage.com/600x400/000/fff&text=23",
    "https://dummyimage.com/600x400/000/fff&text=24",
    "https://dummyimage.com/600x400/000/fff&text=25",
    "https://dummyimage.com/600x400/000/fff&text=26",
    "https://dummyimage.com/600x400/000/fff&text=27",
    "https://dummyimage.com/600x400/000/fff&text=28",
    "https://dummyimage.com/600x400/000/fff&text=29",
    "https://dummyimage.com/600x400/000/fff&text=30",
    "https://dummyimage.com/600x400/000/fff&text=31",
    "https://dummyimage.com/600x400/000/fff&text=32",
    "https://dummyimage.com/600x400/000/fff&text=33",
    "https://dummyimage.com/600x400/000/fff&text=34",
  ];
  List cache = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/images.json');
  }

  Future<List> readImages() async {
    if (cache.isNotEmpty) {
      return cache;
    }
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      cache = jsonDecode(contents);
      return cache;
    } catch (e) {
      // If encountering an error, return 0
      return defaults;
    }
  }

  Future<File> removeImage(String image) async {
    List images = await readImages();
    if (images.contains(image)) {
      images.remove(image);
    }
    final file = await _localFile;

    // Write the file
    return file.writeAsString(jsonEncode(images));
  }
}