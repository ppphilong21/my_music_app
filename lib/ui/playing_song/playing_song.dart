import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music_app/data/model/song.dart';

class PlayingSong extends StatelessWidget {
  const PlayingSong(
      {super.key, required this.playingSong, required this.songs});

  final SongList playingSong;
  final List<SongList> songs;

  @override
  Widget build(BuildContext context) {
    return PlayingSongPage(
      songs: songs,
      playingSong: playingSong,
    );
  }
}

class PlayingSongPage extends StatefulWidget {
  const PlayingSongPage(
      {super.key, required this.songs, required this.playingSong});

  final List<SongList> songs;
  final SongList playingSong;

  @override
  State<PlayingSongPage> createState() => _PlayingSongPageState();
}

class _PlayingSongPageState extends State<PlayingSongPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Playing Song'),
      ),
    );
  }
}
