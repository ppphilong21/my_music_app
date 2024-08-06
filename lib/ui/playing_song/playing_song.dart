import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _audioPlayerManager =
        AudioProgressPlaying(songUrl: widget.playingSong.source);
    _audioPlayerManager.init();
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
            Text(widget.playingSong.album),
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
                  image: widget.playingSong.image,
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
                        Text(widget.playingSong.title),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(widget.playingSong.artist)
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
          return ProgressBar(progress: progress, total: total);
        });
  }
}
