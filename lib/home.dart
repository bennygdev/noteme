import 'package:bennygoh_notion/habit/habit_tracker.dart';
import 'package:bennygoh_notion/note/add_note.dart';
import 'package:bennygoh_notion/note/edit_note.dart';
import 'package:bennygoh_notion/note/search_note.dart';
import 'package:bennygoh_notion/todo/todolist.dart';
import 'package:flutter/material.dart';
import 'data/database_helper.dart';
import 'data/data_classes.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseHelper handler;
  List<Note> _notes = [];
  List<Note> _recentNotes = [];

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    handler.initializeDb();
    loadNotes();
  }

  void loadNotes() async {
    List<Note> notes = await handler.retrieveNotes();
    setState(() {
      _notes = notes;

      _recentNotes = notes..sort((a, b) => b.dateEpochMS.compareTo(a.dateEpochMS));
      _recentNotes = _recentNotes.take(5).toList(); // limit to 5 most recent
    });
  }

  void deleteNote(int id) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel")
          ),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Delete")
          )
        ],
      )
    );

    if (confirmed == true) {
      await handler.deleteNote(id);
      loadNotes(); // reload
    }
  }

  Widget userSection = Column(
    children: [
      Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/profile_picture.png'),
          ),
          SizedBox(width: 15),
          Text(
            "Welcome, User",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF30312C)
            )
          )
        ],
      )
    ],
  );

  Widget recentNoteHeading = Column(
    children: [
      Text(
        "Jump back in",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF787773)
        )
      )
    ],
  );



  @override
  Widget build(BuildContext context) {

    // moved widget component here so context is intialized by build constructor
    Widget noteHeading = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Your Notes",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF787773)
                  )
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddNote(),
                      )
                  ).then((ctx) => loadNotes());
                },
                icon: Icon(
                  Icons.add,
                  color: Color(0xFF787773),
                  size: 28,
                ),
              )
            ],
          ),
        ]
    );

    // not recent notes, just a placeholder (not yet coded the recent note logic)
    Widget recentNotes = SizedBox(
      height: 120,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _recentNotes.length,
          itemBuilder: (context, index) {
            final note = _recentNotes[index];
            return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => EditNote(note: note)))
                      .then((ctx) => loadNotes());
                }, // edit func
                onLongPress: () => deleteNote(note.id!),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.blueGrey,
                  ),
                  width: 150,
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          height: 2 / 3 * 120, // 2/3 of the parent container's height
                          width: 150,
                          color: Colors.transparent,
                          // child: Image.asset(
                          //   'assets/images/profile_picture.png', // pls replace image soon
                          //   fit: BoxFit.cover,
                          // ),
                          child: note.img != null ? Image.file(
                            File(note.img!),
                            fit: BoxFit.cover,
                          ) : Image.asset(
                            'assets/images/profile_picture.png',
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                      Container(
                        height: 1 / 3 * 120, // 1/3 of the parent container's height
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ), // Border radius for the 2/3 container
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              note.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Text color within the white container
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            );
          }
      ),
    );

    Widget noteList = _notes.isEmpty
        ? Center(child: Text("None"))
        : MediaQuery.removePadding( // remove top padidng
      context: context,
      removeTop: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            leading: Icon(
                Icons.description
            ),
            tileColor: Colors.white,
            title: Text(note.title),
            shape: index != _notes.length - 1 ? Border(
              bottom: BorderSide(
                  width: 1,
                  color: Color(0xFFe2e2e2)
              ),
            ) : null,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EditNote(note: note)))
                  .then((ctx) => loadNotes());
            },
            onLongPress: () => deleteNote(note.id!),
          );
        },
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFf7f7f5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userSection,

              _notes.isEmpty ? Column() : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  recentNoteHeading,
                  SizedBox(height: 16),
                  recentNotes,
                ],
              ),
              SizedBox(height: 20),
              noteHeading,
              noteList,
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFFf7f7f5),
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30),
              label: "Search"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium, size: 30),
              label: "Habit tracker"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes, size: 30),
              label: "To do list"
          ),
        ],
        onTap: (i) {
          if (i == 1) {
            // Navigator.of(context).pushNamed("/search");
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => SearchNote(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
          if (i == 2) {
            // Navigator.of(context).pushNamed("/habitTracker");
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HabitTracker(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
          if (i == 3) {
            // Navigator.of(context).pushNamed("/toDoList");
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => ToDoList(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
    );
  }
}
