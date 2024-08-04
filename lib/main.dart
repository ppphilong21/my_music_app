import 'package:flutter/material.dart';

import 'data/repository/repository.dart';

void main() async {
  var repository = DefaultRepository();
  var songs = await repository.loadData();

  if (songs != null){
    for (var song in songs){
      debugPrint(song.title);
    }
  }
}

class MyMusicApp extends StatelessWidget {
  const MyMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


