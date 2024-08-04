import 'dart:convert';

import 'package:my_music_app/data/model/song.dart';
import 'package:http/http.dart' as http;

abstract interface class DataSource {
  Future<List<SongList>?> getSongList();
}

class RemoteDataSource implements DataSource{
  @override
  Future<List<SongList>?> getSongList() async {
    final url = 'https://thantrieu.com/resources/braniumapis/songs.json';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200){
      final preDataSong = utf8.decode(response.bodyBytes);
      var mapDataSong = jsonDecode(preDataSong) as Map;
      var listDataSong = mapDataSong['songs'] as List;
      List<SongList> songs = listDataSong.map((song) => SongList.fromJson(song)).toList();
      return songs;
    }
    else {
      return null;
    }
  }

}

class LocalDataSource implements DataSource{
  @override
  Future<List<SongList>?> getSongList() {
    // TODO: implement getSongList
    throw UnimplementedError();
  }

}