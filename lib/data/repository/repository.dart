import 'package:my_music_app/data/model/song.dart';
import 'package:my_music_app/data/source/source.dart';

abstract interface class Repository {
  Future<List<SongList>?> loadData();
}

class DefaultRepository implements Repository{
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();


  @override
  Future<List<SongList>?> loadData() async {
    List<SongList> songs = [];
    await _remoteDataSource.getSongList().then((data)  {
      if (data == null){
        _localDataSource.getSongList().then((localData)  {
          if (localData != null) {
            songs.addAll(localData);
          }
        });
      }
      else {
        songs.addAll(data);
      }
    });
    return null;
  }

}