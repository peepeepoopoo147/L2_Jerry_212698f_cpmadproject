import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:project/audiohandler.dart';
import 'package:project/library.dart';
import 'package:project/login.dart';
import 'package:project/musichomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/services/firebaseauth_service.dart';
import 'package:project/signup.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  // await startAudioService();
  runApp(MyApp());
}

// Future<void> startAudioService() async {
//   await AudioService.start(
//     backgroundTaskEntrypoint: audioPlayerTaskEntryPoint,
//     androidNotificationChannelName: 'TuneTune Playback',
//     androidNotificationColor:
//         0xFF2196f3, // This is blue, you can use your app's primary color
//     androidNotificationIcon: 'mipmap/ic_launcher', // Use your app icon
//     // Set to true if you want to manage a queue of media items
//     // More configurations can be added as per your requirements
//   );
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuneTune',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black87,
        canvasColor: Colors.transparent,
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/musichome': (context) => MusicHomePage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => MyHomePage(),
        '/profile': (context) => ProfilePage()
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 65),
            Image.asset(
              'images/logo1.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 55),
            Text(
              'Welcome to TuneTune!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 55),
            Text(
              'Discover and listen to music like never before.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'images/circle.svg',
                  semanticsLabel: 'Circle SVG',
                  height: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  'images/music.svg',
                  semanticsLabel: 'Music SVG',
                  height: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  'images/heart.svg',
                  semanticsLabel: 'Heart SVG',
                  height: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  'images/circle.svg',
                  semanticsLabel: 'Circle SVG',
                  height: 10,
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    'Join now',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                var user = await FirebaseAuthService().signInAnonymously();
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MusicHomePage()),
                  );
                }
              },
              child: Text(
                'Continue as a guest',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.grey,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
