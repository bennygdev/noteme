import 'package:flutter/material.dart';
import 'dart:io';
// import 'package:intl/intl.dart';
import '../data/database_helper.dart';
import '../data/data_classes.dart';

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
  File? imageFile; // xfile or file?

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    
    titleController.addListener(() {
      setState(() {});
    });
  }

  void addNote() async {
    if (formKey.currentState!.validate()) {
      final title = titleController.text;
      final description = descriptionController.text;
      final createdDate = DateTime.now().millisecondsSinceEpoch;
      // add image path here

      final note = Note(
        title: title,
        img: null,
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
                  Container(
                    height: 200,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: SizedBox(
                      height: 29,
                      width: 125,
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 20,
                              color: Colors.black,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Change Cover',
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 12,
                              )
                            )
                          ],
                        ),
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          )
                        )
                      )
                    )
                  )
                ],
              ), // add ternary operator before the comma to show the add image button
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
                      }
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
