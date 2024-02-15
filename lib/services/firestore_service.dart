import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/genres.dart';
import 'package:project/models/songs.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Song>> getSongs() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('songs').get();
      List<Song> songs = [];
      querySnapshot.docs.forEach((doc) {
        songs.add(Song.fromMap(doc.data()));
      });
      return songs;
    } catch (e) {
      print('Error getting songs: $e');
      return [];
    }
  }

  Future<List<Genre>> getGenres() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('genres').get();
      List<Genre> genres = [];
      querySnapshot.docs.forEach((doc) {
        genres.add(Genre.fromMap(doc.data()));
      });
      return genres;
    } catch (e) {
      print('Error getting genres: $e');
      return [];
    }
  }

  Future<List<Song>> getSongsByGenre(String genreName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('songs')
          .where('genrename', isEqualTo: genreName)
          .get();
      List<Song> songs =
          querySnapshot.docs.map((doc) => Song.fromMap(doc.data())).toList();
      return songs;
    } catch (e) {
      print('Error getting songs by genre: $e');
      return [];
    }
  }
}
