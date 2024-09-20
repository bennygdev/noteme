import 'package:flutter/material.dart';
import 'dart:io';
// import 'package:intl/intl.dart';
import '../data/database_helper.dart';
import '../data/data_classes.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late DatabaseHelper handler;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  // File? imageFile; // xfile or file? (Note that i want to try XFile, so swap it out please)
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    
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

  void addNote() async {
    if (formKey.currentState!.validate()) {
      final title = titleController.text;
      final description = descriptionController.text;
      final createdDate = DateTime.now().millisecondsSinceEpoch;

      final note = Note(
        title: title,
        img: imageFile?.path,
        description: description,
        dateEpochMS: createdDate,
      );
      await handler.insertNote(note);

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
              addNote();
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,

            )
          )
        ],
        title: Text(
          titleController.text.isEmpty ? 'New Note' : titleController.text,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // ternary operator to add if imagepath exists or not
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
                      width: 105,
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            imageFile = null;
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
                      }
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.comment, size: 20, color: Color(0xFFB9B8B6)),
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
                            // show that modal here!
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
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      maxLines: null,
                    )
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }
}
