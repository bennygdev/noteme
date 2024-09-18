class Note{
  late int id;
  late int dateEpochMS;
  late String title;
  late String? img;
  late String description;

  Note({
    required this.dateEpochMS,
    required this.title,
    required this.img,
    required this.description,
  });

  Note.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    dateEpochMS = map["dateEpochMS"];
    title = map["title"];
    img = map["img"];
    description = map["description"];
  }

  Map<String, dynamic> toMap() {
    return {
      "dateEpochMS": dateEpochMS,
      "title": title,
      "img": img,
      "description": description,
    };
  }
}

class Comment{
  late int id;
  late int noteId;
  late int dateEpochMS;
  late String comment;

  Comment({
    required this.noteId,
    required this.dateEpochMS,
    required this.comment,
  });

  Comment.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    noteId = map["noteId"];
    dateEpochMS = map["dateEpochMS"];
    comment = map["comment"];
  }

  Map<String, dynamic> toMap() {
    return {
      "noteId": noteId,
      "dateEpochMS": dateEpochMS,
      "comment": comment,
    };
  }
}