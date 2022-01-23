// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sharedpref/data_model.dart';
import 'package:sharedpref/widget/card_todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TaskToDo> list = [];
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  DateTime? added;
  DateTime? due;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      backgroundColor: Colors.black,
                      title: Center(
                        child: Text('add new task',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                      content: Container(
                        height: 400,
                        child: Column(
                          children: [
                            Container(
                                height: 75,
                                child: TextField(
                                  controller: title,
                                  cursorColor: Colors.black,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'title',
                                    filled: true,
                                    fillColor: Colors.white70,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                )),
                            Container(
                                height: 90,
                                child: TextField(
                                  controller: content,
                                  maxLines: 10,
                                  cursorColor: Colors.black,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'content',
                                    filled: true,
                                    fillColor: Colors.white70,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                width: double.infinity,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        primary: Colors.black,
                                        backgroundColor: Colors.white70),
                                    onPressed: () async {
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2010),
                                        lastDate: DateTime(2025),
                                      ).then((value) {
                                        added = DateTime.now();
                                        due = value!;
                                        setState(() {});
                                      });
                                    },
                                    child: Text('pick a date'))),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  addItem(TaskToDo(
                                      added.toString(),
                                      content.text,
                                      due.toString(),
                                      title.text));
                                  setState(() {
                                    content.clear();

                                    title.clear();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('add'))
                          ],
                        ),
                      ));
                });
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Todo or not todo',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[600],
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Text('double tap to delete'),
            Builder(builder: (context) {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onDoubleTap: () {
                            removeItem(list[i]);
                          },
                          child: CardToDo(
                            added: list[i].added,
                            due: list[i].due,
                            title: list[i].title,
                            content: list[i].content,
                          ),
                        );
                      }));
            })
          ]),
        ));
  }

  void loadData() {
    List<String>? listString = sharedPreferences.getStringList('list');
    if (listString != null) {
      list = listString
          .map((item) => TaskToDo.fromJson(json.decode(item)))
          .toList();
      setState(() {});
    }
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toJson())).toList();
    sharedPreferences.setStringList('list', stringList);
  }

  void addItem(TaskToDo item) {
    list.insert(0, item);
    saveData();
    setState(() {});
  }

  void removeItem(TaskToDo item) {
    list.remove(item);
    setState(() {});
    saveData();
  }
}
