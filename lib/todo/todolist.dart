import 'package:bennygoh_notion/habit/habit_tracker.dart';
import 'package:bennygoh_notion/home.dart';
import 'package:bennygoh_notion/note/search_note.dart';
import 'package:flutter/material.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf7f7f5),
      body: Column(
        children: [
          Text("Hello")
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
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
          if (i == 1) {
            // Navigator.of(context).pushNamed("/habitTracker");
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
            // Navigator.of(context).pushNamed("/toDoList");
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HabitTracker(),
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
