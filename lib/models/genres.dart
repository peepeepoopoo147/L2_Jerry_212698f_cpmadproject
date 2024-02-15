class Genre {
  String imageUrl;
  String name;

  Genre({this.imageUrl, this.name});

  Genre.fromMap(Map<String, dynamic> data) {
    imageUrl = data['imageUrl'];
    name = data['name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
    };
  }
}
