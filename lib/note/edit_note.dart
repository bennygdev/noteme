import 'package:flutter/material.dart';
import 'dart:io';
import '../data/database_helper.dart';
import '../data/data_classes.dart';
import 'package:image_picker/image_picker.dart';

class EditNote extends StatefulWidget {
  final Note note; // Accept the note to be edited

  const EditNote({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late DatabaseHelper handler;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  XFile? imageFile;

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

    titleController.addListener(() {
      setState(() {});
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: SizedBox(
                      height: 29,
                      width: 125,
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 20, color: Colors.black),
                            SizedBox(width: 5),
                            Text(
                              'Change Cover',
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Wrap(
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
