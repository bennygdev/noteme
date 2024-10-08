import 'package:bennygoh_notion/habit/habit_tracker.dart';
import 'package:bennygoh_notion/home.dart';
import 'package:bennygoh_notion/note/search_note.dart';
import 'package:bennygoh_notion/todo/todolist.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // add theme data here
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (ctx) => HomePage(),
        "/search": (ctx) => SearchNote(),
        "/habitTracker": (ctx) => HabitTracker(),
        "/toDoList": (ctx) => ToDoList(),
      }
    );
  }
}