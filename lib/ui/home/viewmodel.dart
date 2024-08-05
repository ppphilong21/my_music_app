import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../data/model/song.dart';
import '../../data/repository/repository.dart';

class MusicAppViewModel{
  StreamController<List<SongList>> songStream = StreamController();

  void loadSong(){
    final repository = DefaultRepository();
    repository.loadData().then((value) => songStream.add(value!.cast<SongList>()));
  }
}