import 'package:bennygoh_notion/habit/habit_tracker.dart';
import 'package:bennygoh_notion/home.dart';
import 'package:bennygoh_notion/note/edit_note.dart';
import 'package:bennygoh_notion/todo/todolist.dart';
import 'package:flutter/material.dart';
import '../data/data_classes.dart';
import '../data/database_helper.dart';

class SearchNote extends StatefulWidget {
  const SearchNote({Key? key}) : super(key: key);

  @override
  State<SearchNote> createState() => _SearchNoteState();
}

class _SearchNoteState extends State<SearchNote> {
  late DatabaseHelper handler;
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    handler.initializeDb();
    loadNotes();

    searchController.addListener(() {
      filterNotes();
    });
  }

  void loadNotes() async {
    List<Note> notes = await handler.retrieveNotes();
    setState(() {
      _notes = notes;
      _filteredNotes = notes;
    });
  }

  void filterNotes() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isNotEmpty) {
        _filteredNotes = _notes.where((note) =>
        note.title.toLowerCase().contains(query) ||
            note.description.toLowerCase().contains(query))
            .toList();
      } else {
        _filteredNotes = _notes; // show all notes if search is cleared
      }
    });
  }

  void clearSearch() {
    searchController.clear();
  }

  Widget noteHeading = Text(
      "Your Notes",
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF787773)
      )
  );

  @override
  Widget build(BuildContext context) {

    Widget searchBar = Column(
      children: [
        TextField(
          controller: searchController,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            hintText: 'Search...',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFFACABA9),
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              color: Colors.grey,
              onPressed: () {}, // search func
            ),
            suffixIcon: searchController.text.isNotEmpty ? // need fix
                IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.grey,
                  onPressed: clearSearch,
                ) : null,
            filled: true,
            fillColor: Color(0xFFeaeaea),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );

    Widget noteList = _notes.isEmpty
        ? Center(child: Text("None"))
        : MediaQuery.removePadding( // remove top padidng
      context: context,
      removeTop: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          final note = _filteredNotes[index];
          return ListTile(
            leading: Icon(
                Icons.description
            ),
            tileColor: Colors.white,
            title: Text(note.title),
            shape: index != _filteredNotes.length - 1 ? Border(
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
          );
        },
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFf7f7f5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchBar,
              SizedBox(height: 15),
              noteHeading,
              SizedBox(height: 15),
              noteList
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
          if (i == 0) {
            // Navigator.of(context).pushNamed("/search");
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomePage(),
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
