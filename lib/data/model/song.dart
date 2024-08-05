class SongList {
  SongList({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.source,
    required this.duration,
    required this.favorite,
    required this.counter,
    required this.replay,
    required this.image,
  });

  factory SongList.fromJson(Map<String, dynamic> map) {
    return SongList(
      id: map['id'] as String,
      title: map['title'] as String,
      album: map['album'] as String,
      artist: map['artist'] as String,
      source: map['source'] as String,
      duration: map['duration'] as int,
      favorite: map['favorite'] as String,
      image: map['image'] as String,
      counter: map['counter'] as int,
      replay: map['replay'] as int,
    );
  }
  
  String id;
  String title;
  String album;
  String artist;
  String source;
  String image;
  int duration;
  String favorite;
  int counter;
  int replay;
}