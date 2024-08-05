import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music_app/ui/discovery/discovery.dart';
import 'package:my_music_app/ui/home/viewmodel.dart';
import 'package:my_music_app/ui/playing_song/playing_song.dart';
import 'package:my_music_app/ui/setting/setting.dart';
import 'package:my_music_app/ui/user/user.dart';

import '../../data/model/song.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: const MusicHomePage(),
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final List<Widget> _tabs = [
    const HomeTab(),
    const DiscoveryTab(),
    const UserTab(),
    const SettingTab()
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      //Widget provides layout with a navigation bar and content area
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Music App'),
      ), //Thông tin navbar
      child: CupertinoTabScaffold(
        //create bottom navigation bar with many item
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.album), label: 'Discovery'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Setting'),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          //Build/run content of each tabs
          return _tabs[index];
        },
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<SongList> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSong();
    observeData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  Widget getBody() {
    bool isLoading = songs.isEmpty;
    if (isLoading) {
      return getProgessBar();
    } else {
      return getListView();
    }
  }

  Widget getProgessBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  ListView getListView() {
    return ListView.separated(
      itemCount: songs.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          // Adjust padding as needed
          child: SizedBox(
            height: 50,
            child: _SongItemSelection(parent: this, song: songs[index]),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        // Adjust padding as needed
        child: Divider(),
      ),
    );
  }

  void observeData() {
    _viewModel.songStream.stream.listen((song) {
      setState(() {
        songs.addAll(song as Iterable<SongList>);
      });
    });
  }

  void showBottomSheet() {
    showModalBottomSheet(context: context, builder: (context) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          height: 400,
            color: Colors.grey,
          child:const Center(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          )
        ),
      );
    });
  }


  void navigateSong(SongList song) {
    Navigator.push(context,
      CupertinoPageRoute(builder: (context){
        return PlayingSong(
          songs: songs,
          playingSong: song
        );
      })
    );
  }
}

class _SongItemSelection extends StatelessWidget {
  const _SongItemSelection({required this.parent, required this.song});

  final _HomeTabPageState parent;
  final SongList song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FadeInImage.assetNetwork(placeholder: '', image: song.image),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {
          parent.showBottomSheet();
        },
      ),
      onTap: (){
        parent.navigateSong(song);
      },
      // onTap: parent.navigateSong(song)
    );
  }
}
