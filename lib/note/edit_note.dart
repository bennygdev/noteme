import 'package:flutter/material.dart';
import 'dart:io';
import '../data/database_helper.dart';
import '../data/data_classes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditNote extends StatefulWidget {
  final Note note;

  const EditNote({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late DatabaseHelper handler;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final commentController = TextEditingController();
  XFile? imageFile;

  List<Comment> comments = [];
  Map<int, bool> isEditing = {}; // track edits for each comment
  Map<int, TextEditingController> commentControllers = {};
  bool showCommentForm = false;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();

    // init with selected note data
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    if (widget.note.img != null) {
      imageFile = XFile(widget.note.img!);
    }
    loadComments();

    titleController.addListener(() {
      setState(() {});
    });
  }

  loadComments() async {
    comments = await handler.retrieveComments(widget.note.id);
    setState(() {

      // init comment controller
      for (var comment in comments) {
        isEditing[comment.id] = false;
        commentControllers[comment.id] = TextEditingController(text: comment.comment);
      }
    });
  }

  void addComment() async {
    if (commentController.text.isNotEmpty) {
      final comment = Comment(
        noteId: widget.note.id,
        dateEpochMS: DateTime.now().millisecondsSinceEpoch,
        comment: commentController.text,
      );
      await handler.insertComment(comment);
      commentController.clear();
      loadComments();
    }
  }

  void deleteComment(int id) async {
    await handler.deleteSingleComment(id);
    loadComments();
  }

  void updateComment(Comment comment) async {
    if (isEditing[comment.id]!) {
      comment.comment = commentControllers[comment.id]!.text;
      await handler.updateComment(comment);
      setState(() {
        isEditing[comment.id] = false; // exit edit mode after update
      });
    }
  }

  void cancelEdit(int id) {
    setState(() {
      isEditing[id] = false;
      commentControllers[id]!.text =
          comments.firstWhere((c) => c.id == id).comment;
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    setState(() {
      imageFile = pickedImage;
    });
  }

  void editNote() async {
    if (formKey.currentState!.validate()) {

      // old method (creating a new note obj)
      // final note = Note(
      //   title: title,
      //   img: imageFile?.path,
      //   description: description,
      //   dateEpochMS: updatedDate,
      // );
      // note.id = widget.note.id;
      // await handler.updateNote(note);
      widget.note.title = titleController.text;
      widget.note.description = descriptionController.text;
      widget.note.img = imageFile?.path;
      widget.note.dateEpochMS = DateTime.now().millisecondsSinceEpoch;

      await handler.updateNote(widget.note);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              editNote();
            },
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
        ],
        title: Text(
          titleController.text.isEmpty ? 'Edit Note' : titleController.text,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  if (imageFile != null)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: imageFile != null
                          ? DecorationImage(
                        image: FileImage(File(imageFile!.path)),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                  ),
                  if (imageFile != null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: SizedBox(
                        height: 29,
                        width: 100,
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Change Cover',
                                style: TextStyle(
                                  color: Color(0xFF81807C),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              imageFile = null; // Remove the image
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    if (imageFile == null) // show add btn when no img
                      Row(
                        children: [
                          TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: 20, color: Color(0xFFB9B8B6)),
                                SizedBox(width: 5),
                                Text(
                                  'Add cover',
                                  style: TextStyle(
                                    color: Color(0xFFB9B8B6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.camera),
                                        title: Text('Take Photo'),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          await pickImage(ImageSource.camera);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text('Choose from Gallery'),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          await pickImage(ImageSource.gallery);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    if (comments.isEmpty && !showCommentForm)
                      Row(
                        children: [
                          TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.comment,
                                    size: 20, color: Color(0xFFB9B8B6)),
                                SizedBox(width: 5),
                                Text(
                                  'Add comment',
                                  style: TextStyle(
                                    color: Color(0xFFB9B8B6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              setState(() {
                                showCommentForm = true; // show comment form
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (showCommentForm || comments.isNotEmpty)
                      TextFormField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              addComment();
                            }, // Add comment when tapped
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    if (comments.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            title: isEditing[comment.id]!
                                ? TextFormField(
                              controller: commentControllers[comment.id],
                            )
                                : Text(comment.comment),
                            subtitle: Text(
                              DateFormat.yMd()
                                  .add_jm()
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                  comment.dateEpochMS)),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isEditing[comment.id]!)
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      setState(() {
                                        isEditing[comment.id] = true;
                                      });
                                    },
                                  ),
                                if (!isEditing[comment.id]!)
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        deleteComment(comment.id),
                                  ),
                                if (isEditing[comment.id]!)
                                  IconButton(
                                    icon: Icon(Icons.check),
                                    onPressed: () =>
                                        updateComment(comment),
                                  ),
                                if (isEditing[comment.id]!)
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () =>
                                        cancelEdit(comment.id),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
