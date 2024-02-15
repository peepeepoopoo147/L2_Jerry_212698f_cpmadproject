class Song {
  String mediaId;
  String title;
  String artist;
  String imageUrl;
  String songUrl;
  String genreName;

  Song({
    this.mediaId,
    this.title,
    this.artist,
    this.imageUrl,
    this.songUrl,
    this.genreName,
  });

  Song.fromMap(Map<String, dynamic> data) {
    mediaId = data['mediaId'];
    title = data['title'];
    artist = data['artist'];
    imageUrl = data['imageUrl'];
    songUrl = data['songUrl'];
    genreName = data['genrename'];
  }

  Map<String, dynamic> toMap() {
    return {
      'mediaId': mediaId,
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
      'songUrl': songUrl,
      'genrename': genreName,
    };
  }
}
