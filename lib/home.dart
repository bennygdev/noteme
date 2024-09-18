import 'package:bennygoh_notion/habit/habit_tracker.dart';
import 'package:bennygoh_notion/note/search_note.dart';
import 'package:bennygoh_notion/todo/todolist.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

  Widget recentNotes = Column(
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

  Widget notes = Column(
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
            onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf7f7f5),
      // appBar: AppBar(
      //   title: Text("Hello"),
      //   backgroundColor: Colors.blue, // roy did not add appbar, custom
      // ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userSection,
            SizedBox(height: 30),
            recentNotes,
            SizedBox(height: 30),
            notes,
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.transparent,
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
