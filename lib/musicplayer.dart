import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'models/songs.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'services/firestore_service.dart';

class MusicPlayerPage extends StatefulWidget {
  final int currentIndex;

  MusicPlayerPage({Key key, this.currentIndex}) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double _currentSliderValue = 0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isRepeatModeEnabled = false;
  int _currentIndex;
  List<Song> _songs = [];

  void _fetchSongs() async {
    _songs = await FirestoreService().getSongs();
    if (_songs.isNotEmpty) {
      _loadSong(_songs[_currentIndex]);
    }
  }

  void _loadSong(Song song) async {
    try {
      await _audioPlayer.setUrl(song.songUrl);
      _playMusic();
    } catch (e) {
      print("An error occurred while loading the song: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _currentIndex = widget.currentIndex;
    _fetchSongs();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initAudioPlayer() async {
    try {
      _audioPlayer.playerStateStream.listen((playerState) {
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;
        if (processingState == ProcessingState.completed) {
          if (_isRepeatModeEnabled) {
            _audioPlayer.seek(Duration.zero);
            _audioPlayer.play();
          } else {
            _skipNext();
          }
        }
        setState(() {
          this.isPlaying = isPlaying;
        });
      });
      _audioPlayer.positionStream.listen((position) {
        final newPosition = position.inSeconds.toDouble();
        setState(() {
          _currentPosition = position;
          _currentSliderValue = newPosition;
        });
      });

      _audioPlayer.durationStream.listen((totalDuration) {
        setState(() {
          _totalDuration = totalDuration ?? Duration.zero;
        });
      });
    } catch (e) {
      print("An error occurred while loading the song: $e");
    }
  }

  void _playMusic() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _skipNext() {
    if (_songs.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _songs.length;
        _currentPosition = Duration.zero;
        _currentSliderValue = 0;
      });
      _loadSong(_songs[_currentIndex]);
      _playMusic();
    }
  }

  void _skipPrevious() {
    if (_songs.isNotEmpty) {
      setState(() {
        _currentIndex =
            (_currentIndex - 1) < 0 ? _songs.length - 1 : _currentIndex - 1;
        _currentPosition = Duration.zero;
        _currentSliderValue = 0;
      });
      _loadSong(_songs[_currentIndex]);
      _playMusic();
    }
  }

  void _repeatSong() {
    setState(() {
      _isRepeatModeEnabled = !_isRepeatModeEnabled;
      _audioPlayer
          .setLoopMode(_isRepeatModeEnabled ? LoopMode.one : LoopMode.off);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding =
        MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Now playing',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_songs[_currentIndex].imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: topPadding),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(16.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(_songs[_currentIndex].imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _songs[_currentIndex].title,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.green,
                          size: 24.0,
                        ),
                        onPressed: () {
                          //Future
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _songs[_currentIndex].artist,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_currentPosition),
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      Text(
                        _formatDuration(_totalDuration),
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.greenAccent,
                    inactiveTrackColor: Colors.greenAccent.withOpacity(0.3),
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 2.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                    thumbColor: Colors.greenAccent,
                    overlayColor: Colors.green.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.greenAccent,
                    inactiveTickMarkColor: Colors.greenAccent.withOpacity(0.3),
                  ),
                  child: Slider(
                    value: _currentPosition.inSeconds.toDouble(),
                    min: 0,
                    max: _totalDuration.inSeconds.toDouble() ?? 1,
                    onChanged: (value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                    onChangeEnd: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'images/backward.svg',
                        color: Colors.white,
                        height: 32.0,
                      ),
                      onPressed: _skipPrevious,
                    ),
                    SizedBox(width: 32.0),
                    IconButton(
                      icon: isPlaying
                          ? SvgPicture.asset(
                              'images/pause.svg',
                              color: Colors.white,
                              height: 64.0,
                            )
                          : SvgPicture.asset(
                              'images/play.svg',
                              color: Colors.white,
                              height: 64.0,
                            ),
                      onPressed: _playMusic,
                    ),
                    SizedBox(width: 32.0),
                    IconButton(
                      icon: SvgPicture.asset(
                        'images/forward.svg',
                        color: Colors.white,
                        height: 32.0,
                      ),
                      onPressed: _skipNext,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 35.0),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'images/repeat.svg',
                          color: _isRepeatModeEnabled
                              ? Colors.green
                              : Colors.white.withOpacity(0.6),
                          height: 24.0,
                        ),
                        onPressed: _repeatSong,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
