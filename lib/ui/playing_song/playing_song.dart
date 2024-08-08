import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_app/data/model/song.dart';

import 'audio_progress_playing.dart';

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

class _PlayingSongPageState extends State<PlayingSongPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late AudioProgressPlaying _audioPlayerManager;
  late int _selectedItemIndex;
  late SongList _song;
  late double currentPositionAnimated;
  late bool _isShuff;

  @override
  void initState() {
    super.initState();
    _song = widget.playingSong;
    currentPositionAnimated = 0.0;
    _isShuff = false;
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _audioPlayerManager =
        AudioProgressPlaying(songUrl: _song.source);
    _audioPlayerManager.init();
    _selectedItemIndex = widget.songs.indexOf(widget.playingSong);
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Playing Song'),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ),
        child: Scaffold(
            body: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_song.album),
            const SizedBox(
              height: 16,
            ),
            const Text('_______'),
            const SizedBox(
              height: 48,
            ),
            RotationTransition(
              turns: Tween<double>(begin: -200, end: 0)
                  .animate(_animationController),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: FadeInImage.assetNetwork(
                  placeholder: '',
                  image: _song.image,
                  width: screenWidth - delta,
                  height: screenWidth - delta,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 64, bottom: 16),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined)),
                    Column(
                      children: [
                        Text(_song.title),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(_song.artist)
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border_outlined)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 32, bottom: 16, left: 24, right: 24),
              child: _progressBar(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 32, bottom: 16, left: 24, right: 24),
              child: _mediaButton(),
            )
          ],
        ))));
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return ProgressBar(
            progress: progress,
            total: total,
            buffered: buffered,
            onSeek: _audioPlayerManager.player.seek,
            barHeight: 5.0,
            barCapShape: BarCapShape.round,
            baseBarColor: Colors.grey.withOpacity(0.3),
            progressBarColor: Colors.deepPurple,
            bufferedBarColor: Colors.grey.withOpacity(0.3),
            thumbColor: Colors.deepPurple,
            thumbGlowColor: Colors.green.withOpacity(0.3),
            thumbRadius: 10,
          );
        });
  }

  Widget _mediaButton() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButton(
              function: _setShuff,
              icon: Icons.shuffle,
              color: getShuffColor(),
              size: 24),
          MediaButton(
              function: _setPreviousSong,
              icon: Icons.skip_previous,
              color: Colors.deepPurple,
              size: 36),
          _playButton(),
          MediaButton(
              function: _setNextSong,
              icon: Icons.skip_next,
              color: Colors.deepPurple,
              size: 36),
          MediaButton(
              function: null,
              icon: Icons.monitor_heart_rounded,
              color: Colors.grey,
              size: 24),
        ],
      ),
    );
  }

  void _setShuff(){
    setState(() {
      _isShuff = !_isShuff;
    });
  }

  Color? getShuffColor(){
    return _isShuff ? Colors.deepPurple : Colors.grey;
  }

  void _setPreviousSong(){
    if (_isShuff){
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    }
    else {
      --_selectedItemIndex;
    }
    if (_selectedItemIndex < 0){
      _selectedItemIndex = (-1 * _selectedItemIndex) % widget.songs.length;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    setState(() {
      _song = nextSong;
    });
  }

  void _setNextSong(){
    if (_isShuff){
        var random = Random();
        _selectedItemIndex = random.nextInt(widget.songs.length);
    }
    else {
      ++_selectedItemIndex;
    }
    if (_selectedItemIndex > widget.songs.length){
      _selectedItemIndex = _selectedItemIndex % widget.songs.length;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    setState(() {
      _song = nextSong;
    });
  }

  //Lắng nghe sự thay đổi của dữ liệu bài hát: Load bài hát, ngưng, tua bài
  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder(
        stream: _audioPlayerManager.player.playerStateStream,
        builder: (context, snapshot) {
          final playState = snapshot.data; //Trạng thái mới nhất
          final procressingState = playState?.processingState;
          final playing = playState?.playing;
          //nhạc đang chờ tải
          if (procressingState == ProcessingState.loading ||
              procressingState == ProcessingState.buffering) {
            return Container(
              margin: const EdgeInsets.all(8),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          }
          //nhạc đang dừng
          else if (playing != true) {
            return MediaButton(
                function: () {
                  _audioPlayerManager.player.play();
                },
                icon: Icons.play_arrow,
                color: Colors.deepPurple,
                size: 48);
          }
          //nhạc đang phát
          else if (procressingState != ProcessingState.completed) {
            return MediaButton(
                function: () {
                  _audioPlayerManager.player.pause();
                },
                icon: Icons.pause,
                color: Colors.deepPurple,
                size: 48);
          }
          //reset về chu kỳ phát ban đầu
          else {
            return MediaButton(
                function: () {
                  _audioPlayerManager.player.seek(Duration.zero);
                },
                icon: Icons.replay,
                color: Colors.deepPurple,
                size: 48);
          }
        });
  }
}

class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl(
      {super.key,
      required this.function,
      required this.icon,
      required this.color,
      required this.size});

  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  @override
  State<MediaButtonControl> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      color: widget.color ?? Theme.of(context).colorScheme.primary,
      iconSize: widget.size,
    );
  }
}

class MediaButton extends StatefulWidget {
  const MediaButton(
      {super.key,
      required this.function,
      required this.icon,
      required this.color,
      required this.size});

  final void Function()? function;
  final IconData icon;
  final Color? color;
  final double? size;

  @override
  State<MediaButton> createState() => _MediaButtonState();
}

class _MediaButtonState extends State<MediaButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      iconSize: widget.size,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
