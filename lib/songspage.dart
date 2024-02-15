import 'package:flutter/material.dart';
import 'package:project/bottomnavbar.dart';
import 'package:project/services/firebaseauth_service.dart';

import 'models/songs.dart';
import 'musicplayer.dart';

class SongsPage extends StatefulWidget {
  final List<Song> songs;
  final String genreName;

  SongsPage({Key key, this.songs, this.genreName}) : super(key: key);

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${widget.genreName} songs',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.songs.length,
              itemBuilder: (context, index) {
                Song song = widget.songs[index];
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
            ),
          ),
        ],
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
}
