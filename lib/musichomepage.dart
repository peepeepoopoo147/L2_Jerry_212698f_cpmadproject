import 'package:flutter/material.dart';
import 'package:project/bottomnavbar.dart';
import 'package:project/musicplayer.dart';
import 'package:project/services/firebaseauth_service.dart';
import 'package:project/services/firestore_service.dart';
import 'package:project/songspage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'models/genres.dart';
import 'models/songs.dart';

class MusicHomePage extends StatefulWidget {
  @override
  _MusicHomePageState createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  FirestoreService _firestoreService = FirestoreService();
  FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int hour = now.hour;
    String greeting = _getGreeting(hour);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '$greeting!',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    'images/logout.svg',
                    semanticsLabel: 'Circle SVG',
                    height: 30,
                  ),
                  onPressed: () async {
                    await FirebaseAuthService().signOut();
                    Navigator.of(context).pushNamed('/home');
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Text(
                'Genres',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            _buildHorizontalGenreList(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Popular songs',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            _buildSongList(),
          ],
        ),
      ),
      bottomNavigationBar: FutureBuilder<bool>(
        future: _authService.isUserAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink();
          } else {
            final bool isAuthenticated = snapshot.data ?? false;
            return isAuthenticated ? BottomNavBar() : Container();
          }
        },
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
    );
  }

  Widget _buildHorizontalGenreList() {
    return FutureBuilder<List<Genre>>(
      future: _firestoreService.getGenres(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final genres = snapshot.data ?? [];
          return Container(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (BuildContext context, int index) {
                final genre = genres[index];
                return InkWell(
                  onTap: () {
                    _loadSongsForGenre(genre);
                  },
                  child: Container(
                    width: 150.0,
                    margin: EdgeInsets.only(
                        left: 16.0,
                        right: index == genres.length - 1 ? 16.0 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(genre.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        Center(
                          child: Text(
                            genre.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildSongList() {
    return FutureBuilder<List<Song>>(
      future: _firestoreService.getSongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final songs = snapshot.data ?? [];
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: songs.length,
            itemBuilder: (BuildContext context, int index) {
              final song = songs[index];
              return ListTile(
                leading: ClipOval(
                  child: Image.network(
                    song.imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                title: Text(
                  song.title,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  song.artist,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.play_arrow, color: Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicPlayerPage(
                        currentIndex: index,
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                tileColor: Colors.black.withOpacity(0.4),
              );
            },
          );
        }
      },
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  void _loadSongsForGenre(Genre genre) async {
    try {
      List<Song> songs = await _firestoreService.getSongsByGenre(genre.name);
      print('Songs for ${genre.name}: ${songs.length}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SongsPage(songs: songs, genreName: genre.name),
        ),
      );
    } catch (e) {
      print('Error loading songs for genre: $e');
    }
  }
}
