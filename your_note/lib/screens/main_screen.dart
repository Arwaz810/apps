import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_note/db/datbaseprovider.dart';
import 'package:your_note/models/notes.dart';
import 'package:sqflite/sqlite_api.dart';
import 'add_note.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  DatabaseProvider databaseProvider = DatabaseProvider();
  List<Note> mainScreen;
  int count = 0;
  int axisCount = 2;
  @override
  Widget build(BuildContext context) {
    if (mainScreen == null) {
      mainScreen = [];
      updateNotesList();
    }
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'YOUR NOTES',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.amber[50],
        child: getNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          navAddNote(Note('', '', 3), 'Add Note');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getNotes() {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          navAddNote(this.mainScreen[index], 'Edit Note');
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                // color: Colors[this.mainScreen[index].color],
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        this.mainScreen[index].title,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          this.mainScreen[index].description == null
                              ? ''
                              : this.mainScreen[index].description,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  void updateNotesList() {
    final Future<Database> dbFuture = databaseProvider.initializeDataBase();
    dbFuture.then((database) {
      Future<List<Note>> notesListFuture = databaseProvider.getNoteList();
      notesListFuture.then((mainScreen) {
        setState(() {
          this.mainScreen = mainScreen;
          this.count = mainScreen.length;
        });
      });
    });
  }

  void navAddNote(Note mainScreen, String title) async {
    // ignore: unused_local_variable
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddNote(mainScreen, title)));
    if (result = true) {
      updateNotesList();
    }
  }
}
