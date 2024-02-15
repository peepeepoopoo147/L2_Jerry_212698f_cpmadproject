import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/aboutus.dart';
import 'package:project/updateprofile.dart';
import 'services/firebaseauth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User currentUser;
  FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: currentUser.photoURL != null
                  ? NetworkImage(currentUser.photoURL)
                  : AssetImage('images/userimage.jpg'),
            ),
            SizedBox(height: 8),
            Text(
              currentUser.displayName ?? 'No Name',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('556 Following', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 10),
                Text('•', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 10),
                Text('929 Followers', style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Playlists'),
            _buildPlaylistItem('Art Techno', '120 likes'),
            _buildPlaylistItem('WorkOut', '600 likes'),
            _buildPlaylistItem('Quiet Hours', '101 likes'),
            _buildPlaylistItem('Deep Focus', '93 likes'),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
              child: Text('About Us'),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue,
                side: BorderSide(color: Colors.blue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                );
              },
              child: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Spacer(),
          Text('Downloaded', style: TextStyle(color: Colors.grey)),
          SizedBox(width: 20),
          Text('Liked', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem(String title, String likes) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
      ),
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(likes, style: TextStyle(color: Colors.grey)),
      trailing: Icon(Icons.chevron_right, color: Colors.white),
      onTap: () {},
    );
  }
}
